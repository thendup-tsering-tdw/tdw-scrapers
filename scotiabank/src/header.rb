require 'mechanize'
require 'awesome_print'
require 'zip'
require 'open-uri'
require 'progressbar'
require 'net/http'
require 'uri'
require 'tempfile'
require 'nokogiri'
require 'csv'
require 'titleize'

$VERBOSE = nil

# **************************** Helper Functions ****************************

def agent
  @agent ||= Mechanize.new
end

def extract(file)
  puts "Extracting #{filename}"
  Zip::File.open(file) do |zip_file|
    zip_file.each do |entry|
      entry.extract(dest_file)
    end
  end
end

def cleanElement(elem)
  ret = elem
  unless elem.titleize == "Not Available"
    ret = elem.gsub(" ",",")
  end
  ret
end

def pullInfo(info, type)
  result = nil
  splitInfo = info.split("\n")
  if type == "name"
    result = splitInfo[0] unless splitInfo == nil
  elsif type == "addr" && splitInfo.length > 1
    result = splitInfo[1..splitInfo.length].join(", ")
  end
  result
end

# ****************************** Classes ******************************


class RedirectFollower
  class TooManyRedirects < StandardError; end

  attr_accessor :url, :body, :redirect_limit, :response

  def initialize(url, limit=5)
    @url, @redirect_limit = url, limit
  end

  def resolve
    raise TooManyRedirects if redirect_limit < 0

    self.response = Net::HTTP.goo_Geocode(URI.parse(url))

    if response.kind_of?(Net::HTTPRedirection)
      self.url = redirect_url
      self.redirect_limit -= 1
      resolve
    end

    self.body = response.body
    self
  end

  def redirect_url
    if response['location'].nil?
      response.body.match(/<a href=\"([^>]+)\">/i)[1]
    else
      response['location']
    end
  end
end


class DownloadRetrier

  MAX_RETRIES = 10

  attr_accessor :tries, :resolver

  def initialize(resolver)
    @resolver = resolver
  end

  def resolve
    response = nil
    tries = 0
    while (tries += 1) < MAX_RETRIES
      begin
        # puts "Try ##{tries}"
        return resolver.resolve
      rescue Net::ReadTimeout
      end
    end
  end
end

class LinkProcessor # Used for USRunner and CanadaRunner.runOpen

  attr_reader :link

  def initialize(link)
    @link = link
  end

  def headers
    ["publishing_status","contract_award_date","publication_date","amendment_date","contract_number","contract_sequence_number","currency","value","amendment_number","reference_number",	"solicitation_number","gsin_description","gsin_link",	"procurement_entity","end_user_entity", "customer_name", "customer_address", "supplier_name", "supplier_address", "award_description"]
  end

  def call(file_type)
    if File.exist?(dest_file)
      puts "File #{dest_file} already exists"
      return
    else
      puts "Downloading #{save_name}"
      process_link(file_type)
    end
  end

  def call_special(outfile)
    if File.exist?(dest_file)
      puts "File #{dest_file} already exists"
      return
    else
      puts "Downloading #{save_name}"
      process_link_special(outfile)
    end
  end

  private

  def filename
    link.text().strip
  end

  def dest_file
    '../output/' + link.href().match(/\/([^\/]*)$/)[1].gsub('.zip','')
  end

  def save_name
    link.href().match(/\/([^\/]*)$/)[1]
  end

  def response
    @response ||= DownloadRetrier.new(RedirectFollower.new(link.href())).resolve
  end

  def process_link(file_type)
    if response.nil?
      STDERR.puts "Error on file: #{filename}"
    else
      if file_type == '.zip'
        extractResponse(response)
      elsif file_type == '.csv'
        saveResponse(response)
      end
      puts "Saved as #{dest_file}"
    end
  end

  def process_link_special(outfile)
    if response.nil?
      STDERR.puts "Error on file: #{filename}"
    else
      writeResponseToCsv(response,outfile)
      puts "Saved to #{dest_file}"
    end
  end

  def saveResponse(response)
    File.open(dest_file,'w') do |outfile|
      outfile.write(response.body)
    end
  end

  def extractResponse(response)
    begin
      # Write to tempfile
      file = Tempfile.new('archive.zip')
      file.write(response.body)
      extract(file)
      file.close
    rescue StandardError => e
      STDERR.puts "Error extracting file. #{e.message}"
    ensure
      file.unlink if file
    end
  end

  def writeResponseToCsv(response,outfile)
    parseDoc = Nokogiri::HTML(response.body)
    outfile << CSV::Row.new(headers, []).tap do |row|
      row["publishing_status"] = parseDoc.xpath('//*[contains(@class,"publishing-status")]/span/text()').to_s # Publishing Status
      row["contract_award_date"] = parseDoc.xpath('//*[contains(@class,"date-award")]/span/text()').to_s # Contract Award Date
      row["publication_date"] = parseDoc.xpath('//*[contains(@class,"publication-date")]/span/text()').to_s # Publication Date
      row["amendment_date"] = parseDoc.xpath('//*[contains(@class,"amendment-date")]/span/text()').to_s # Amenement Date
      row["contract_number"] = parseDoc.xpath('//*[contains(@class,"contract-number")]/span/text()').to_s.strip # Contract Number
      row["contract_sequence_number"] = parseDoc.xpath('//*[contains(@class,"award-number-1")]/span/text()').to_s # Contract Sequence Number
      row["currency"] = parseDoc.xpath('//*[contains(@class,"php-4")]/span/abbr/text()').to_s # Currency
      row["value"] = cleanElement(parseDoc.xpath('//*[contains(@class,"php-4")]/span/text()').to_s.strip) # Value
      row["amendment_number"] = parseDoc.xpath('//*[contains(@class,"amendment-number")]/span/text()').to_s # Amendment Number
      row["reference_number"] = parseDoc.xpath('//*[contains(@class,"reference-number")]/span/text()').to_s # Reference Number
      row["solicitation_number"] = parseDoc.xpath('//*[contains(@class,"solicitation-number")]/span/text()').to_s # Solicitation Number
      row["gsin_description"] = parseDoc.xpath('//*[contains(@class,"gsin")]//*/a/text()').to_s # gsin desc
      row["gsin_link"] = parseDoc.xpath('//*[contains(@class,"gsin")]//*/a/@href').to_s # gsin link
      row["procurement_entity"] = parseDoc.xpath('//*[contains(@class,"procurement-entity")]/span/text()').to_s.gsub('&amp;','&') # Procurement Entity
      row["end_user_entity"] = parseDoc.xpath('//*[contains(@class,"end-user-entity")]/span/text()').to_s.gsub('&amp;','&') # End User Entity
      customer_info = parseDoc.xpath('//*[@id="main-content"]/article/div/div/div/div/div[2]/div[1]/div/div/pre/text()').to_s.gsub("&amp;","&")
      row["customer_name"] = pullInfo(customer_info,"name") # Customer Name
      row["customer_address"] = pullInfo(customer_info,"addr") # Customer Address
      supplier_info = parseDoc.xpath('//*[@id="main-content"]/article/div/div/div/div/div[2]/div[2]/div/div[1]/pre/text()').to_s.gsub("&amp;","&")
      row["supplier_name"] = pullInfo(supplier_info,"name") # Supplier Name
      row["supplier_address"] = pullInfo(supplier_info,"addr") # Supplier Address
      row["award_description"] = parseDoc.xpath('//*[contains(@class,"award_description")]/pre/text()').to_s.gsub("\n"," ") # Award Description
    end
  end

end
