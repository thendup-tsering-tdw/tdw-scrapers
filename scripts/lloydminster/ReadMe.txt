Lloydminster:
  Step 1: Pull all the data
    Usage: ruby get.rb #{shardIdx} #{shardSize}

    The script will pull json data and store it in the current directory by page i.e. '1.json'. According to the
    site(http://col.lloydminster.ca/colmap/), there are 12,500 records split across 250 pages giving
    50 records per page.

    There are 250 requests to be made for Lloydminster.

  Step 3: Parse the data
    This step will reference the files in the 'get' directory
    Usage ruby parse.rb #{shardIdx} #{shardSize} > #{outFileName}.csv
