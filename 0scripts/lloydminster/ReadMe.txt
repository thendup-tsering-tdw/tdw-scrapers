Lloydminster:
  Step 1: Pull all the map data
    Usage: 'ruby getMapData.rb #{shardIdx} #{shardSize}'

    We need to check the last page to make sure all data is pulled.
      Numbers below are current as of writing this ReadMe

    This script will pull html data and store it in the pulled directory by page
    i.e. 'page_1.html'. According to the site(http://col.lloydminster.ca/colmap/),
    there are 12,500 records split across 250 pages giving about 50 records per page.


  Step 2: Pull all the HTML data
    Usage: 'ruby getHtmlData.rb #{shardIdx} #{shardSize}'

    This script will pull html data which includes assessment value information
    and store it in the pulled directory by index i.e. 'print_8760.html'. Running this
    script should pull about 12,500 files.


  Step 3: Parse the data
    -This step will first reference the land files in the 'pulled' directory. The script will
    create a hash of all the records in the files within this directory having the 'Legal Description'
    number as a reference.
    -Then the page files in the 'pulled' directory for lloydminster will be merged
    link them with the print files using the Legal description field as a reference.
    
    Usage 'ruby parse.rb > ../../../2parsed/lloydminster/#{outFileName}.csv'
