Morinville:
  Step 1: Pull all the pdf file data
    Usage: ruby getPdfData.rb #{shardIdx} #{shardSize}'

    The script will pull pdf files into the working directory. Each pdf file will have
    a name of the format 321YXXXXX2014_110.pdf where YXXXXX varies from 000000 to 999999.

    There are 1,000,000 get requests for morinville to be performed, most of which are located
    where Y = 0

    Count:
    - Initial Run: 2448 (only with XXXXX loop)
    - Current Run: 4036 (with YXXXXX loop)


  Step 2: Pull all the additional map data
    Usage: 'ruby getMapData.rb'

    The script will pull additional data including LINC numbers using the existing pdf
    file data as a reference for which data to pull. This script does not employ the
    shard concept. The data will be stored in a json file in the pulled directory as
    lincData.json


  Step 3: Parse the data
    Usage 'ruby parse.rb > ../../../2parsed/morinville/#{outFileName}.csv'
