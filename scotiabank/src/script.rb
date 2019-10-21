require './header'

# ******************************** US ********************************

class USRunner

  def run_range(start_year = 2000, end_year = Date.today.strftime("%Y").to_i)
    (start_year..end_year).each do |year|
      run_single(year)
    end
  end

  def run_single(year)
    agent.get('https://apps.usaspending.gov/DownloadCenter/AgencyArchive') do |page|
      get_links(page,year).each do |link|
        LinkProcessor.new(link).call('.zip')
      end
    end
  end



  private

  def get_links(page,year)
    myForm = page.forms[0]
    myForm.FiscalYearSelected = year
    result = myForm.submit
    result.links
  end

end


# ****************************** Canada ******************************

class CanadaRunner

  def runOpen
    agent.get('http://open.canada.ca/data/en/dataset/53753f06-8b28-42d7-89f7-04cd014323b0') do |page|
      page.links.each do |link|
        if link.href == 'https://buyandsell.gc.ca/cds/public/contracts/tpsgc-pwgsc_co-ch_tous-all.csv'
          LinkProcessor.new(link).call('.csv')
        end
      end
    end
  end

  def runGC
    CSV.open(dest_file, 'a+', headers: headers, write_headers: write_headers) do |outfile|
      (0..last_page).each do |page|
        page_link = 'https://buyandsell.gc.ca/procurement-data/search/site?page=' + page.to_s + '&f%5B0%5D=sm_facet_procurement_data%3Adata_data_tender_award&f%5B1%5D=dds_facet_date_published%3Adds_facet_date_published_today'
        # page_link = 'https://buyandsell.gc.ca/procurement-data/search/site?page=' + page.to_s + '&f%5B0%5D=sm_facet_procurement_data%3Adata_data_tender_award&f%5B1%5D=dds_facet_date_published%3Adds_facet_date_published_7day'
        run_page_link(page_link,outfile)
      end
    end
  end


  private

  def dest_file
    '../output/gcCanada.csv'
  end

  def run_page_link(page_link,outfile)
    agent.get(page_link) do |page|
      process_links(page,outfile)
    end
  end

  def process_links(page,outfile)
    page.links.each do |link|
      if link_match(link) != nil
        LinkProcessor.new(link).call_special(outfile)
      end
    end
  end

  def link_match(link)
    link.href().match(/https:\/\/buyandsell.gc.ca\/procurement-data\/award-notice\/(.*)/)
  end

  def headers
    ["publishing_status","contract_award_date","publication_date","amendment_date","contract_number","contract_sequence_number","currency","value","amendment_number","reference_number",	"solicitation_number","gsin_description","gsin_link",	"procurement_entity","end_user_entity", "customer_name", "customer_address", "supplier_name", "supplier_address", "award_description"]
  end

  def write_headers
    !File.exist?(dest_file)
  end

  def last_page
    last_page_link = nil
    page = 0
    agent.get('https://buyandsell.gc.ca/procurement-data/search/site?f%5B0%5D=sm_facet_procurement_data%3Adata_data_tender_award&f%5B1%5D=dds_facet_date_published%3Adds_facet_date_published_today') do |page|
      # agent.get('https://buyandsell.gc.ca/procurement-data/search/site?f%5B0%5D=sm_facet_procurement_data%3Adata_data_tender_award&f%5B1%5D=dds_facet_date_published%3Adds_facet_date_published_7day') do |page|
      page.links.each do |link|
        if link.text().split(" ").first == "last"
          last_page_link = link.href()
        end
      end
    end
    unless last_page_link == nil
      last_page_link.match(/\?page=(\d*)&/) do |matching|
        page = matching[1].to_i unless matching == nil
      end
    end
    page
  end

end


