Spruce:
  Step 1: Pull all the data

    With a), b) and c) need to check the last page to make sure all data is pulled.
      Numbers below are current as of writing this ReadMe

    The script will pull three types of data
    a) Assessment Data: Search > Property > Assessment > Search
      Usage: ruby get.rb asmt #{shardIdx} #{shardSize}
      -Data will be stored in the current directory by page i.e. 'ast1.html'.
      -According to the site(http://maps.sprucegrove.org/public/Default.aspx),
        there are 15088 records split across 1509 pages giving about 10 records per page.
      -There are 1509 requests to be made for Spruce Grove Assessment Data.

    b) Parcel Data: Search > Property > Address > Search
      Usage: ruby get.rb prcl #{shardIdx} #{shardSize}
      -Should run from 0 to 1456 i.e shardIdx = 0 && shardSize = 1456
      -Data will be stored in the current directory by page i.e. 'prcl1.html'.
      -According to the site(http://maps.sprucegrove.org/public/Default.aspx),
        there are 14599 records split across 1456 pages giving about 10 records per page.
      -There are 1456 requests to be made for Spruce Grove Parcel Data.

    c) Land Data: Search > Property > Assessment > Search > Check 'All Pages' > Select 'Land Use' from dropdown
      Usage: ruby get.rb land #{shardIdx} #{shardSize}
      -Should run from 0 to 1227 i.e shardIdx = 0 && shardSize = 1227
      -Data will be stored in the current directory by page i.e. 'lnd1.html'.
      -According to the site(http://maps.sprucegrove.org/public/Default.aspx),
        there are 12261 records split across 1227 pages giving about 10 records per page.
      -There are 1227 requests to be made for Spruce Grove Assessment Data.


  Step 4: Parse the data
    Usage 'ruby parse.rb > ../../../2parsed/spruce/#{outFileName}.csv'

    -This step will first reference the land files in the 'pulled' directory. The script will
    create a hash of all the records in the files within this directory having the 'PID'
    number as a reference.
    -Then the script will reference the prcl files in the 'pulled' directory will create another
    hash of the Parcel data which would contain the record and its respective Legal Description
    also having the 'Roll' number as a reference
    -Finally the script will reference all the asmt files in the 'pulled' directory and will
    merge all the data in with the data from the first two hashes by linking them using the
    Roll and LINC numbers.
