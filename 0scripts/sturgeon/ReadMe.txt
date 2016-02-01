Sturgeon:
  Step 1: Pull all the data
    Usage: ruby get.rb #{shardIdx} #{shardSize}

    The script will pull pdf files into the working directory. Each pdf file will have
    a name of the format XXXXXX2014_110.pdf where XXXXXX varies from 000000 to 999999.

    There are 1,000,000 get requests for Sturgeon to be performed

    Count:
    - Initial Run: 2665 (only with XXXXX loop)
    - Current Run: 11952 (with XXXXXX loop)

  Step 2: Convert all pdf files to txt files
    Go to the pulled directory for sturgeon and run the following
      a) 'for file in *.pdf; do pdftotext "$file" "$file.txt"; done'

  Step 3: Parse the data
    Usage 'ruby parse.rb > ../../../2parsed/sturgeon/#{outFileName}.csv'
