Morinville:
  Step 1: Pull all the data
    Usage: ruby get.rb #{shardIdx} #{shardSize}

    The script will pull pdf files into the working directory. Each pdf file will have
    a name of the format 321YXXXXX2014_110.pdf where YXXXXX varies from 000000 to 999999.

    There are 1,000,000 get requests for morinville to be performed, most of which are located
    where Y = 0

    Count:
    - Initial Run: 2448 (only with XXXXX loop)
    - Current Run: 4036 (with YXXXXX loop)

  Step 2: Convert all pdf files to txt files
    Go to the pulled directory for morinville and run the following
      a) 'for file in *.pdf; do pdftotext "$file" "$file.txt"; done'

  Step 3: Parse the data
    Usage 'ruby parse.rb > ../../../2parsed/morinville/#{outFileName}.csv'
