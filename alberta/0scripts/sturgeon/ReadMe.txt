Sturgeon:
  Step 1: Pull all the pdf file data
    Usage: 'ruby getPdfData.rb #{shardIdx} #{shardSize}'

    The script will pull pdf files into the working directory. Each pdf file will have
    a name of the format XXXXXX2014_110.pdf where XXXXXX varies from 000000 to 999999.

    There are 1,000,000 get requests for Sturgeon to be performed for pdf data

    Count:
    - Initial Run: 2665 (only with XXXXX loop)
    - Current Run: 11952 (with XXXXXX loop)


  Step 2: Pull all the additional map data
    Usage: 'ruby getMapData.rb #{shardIdx} #{shardSize}'

    The script will pull additional data including LINC numbers. The data will
    be stored in a json file in the pulled directory as data.json

    There are 100,000 get requests for Sturgeon to be performed for map data


  Step 3: Parse the data
    Usage 'ruby parse.rb > ../../../2parsed/sturgeon/#{outFileName}.csv'
