Lloydminster:
  Step 1: Pull all the data

    We need to check the last page to make sure all data is pulled.
      Numbers below are current as of writing this ReadMe

    Usage: ruby get.rb #{shardIdx} #{shardSize}

    The script will in html data and store it in the current directory by page
    i.e. '1.html'. According to the site(http://col.lloydminster.ca/colmap/),
    there are 12,500 records split across 250 pages giving about 50 records per page.

    There are 250 requests to be made for Lloydminster.

  Step 3: Parse the data
    This step will reference the files in the 'get' directory
    Usage 'ruby parse.rb > ../../../2parsed/lloydminster/#{outFileName}.csv'
