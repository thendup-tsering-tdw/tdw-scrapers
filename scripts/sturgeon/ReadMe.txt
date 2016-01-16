Sturgeon:
  Step 1: Pull all the data
    Usage: ruby get.rb #{shardIdx} #{shardSize}

    The script will pull pdf files into the working directory. Each pdf file will have
    a name of the format XXXXXXXXX2014_110.pdf where XXXXXXXXX varies from 000000000 to 999999999.

    There are 100,000,000 get requests for Sturgeon to be performed

  Step 2: Convert all pdf files to txt files
    Go to the get directory and run the following
      a) 'for file in *.pdf; do pdftotext "$file" "$file.txt"; done'
      b) 'mv *.txt ../parse'

  Step 3: Parse the data
    Usage ruby parse.rb #{shardIdx} #{shardSize} > #{outFileName}.csv
