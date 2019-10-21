def remove_spaces(str)
  str.gsub(/\t|\n|\r|\s{2,}/, ' ').gsub(/\s{2,}/, ' ').gsub("\u00A0", '').strip
end
​
def check_in(page)
  tmp = page.css('div#factSheetAmenities > div > table > tr > td').first.text
  remove_spaces(tmp.gsub('Check In:', ''))
end

# #def hotel_name(page, text)
# 	tmp = page.css('div#factSheetHotelDetail > .factSheetHotelName').first.text

def name(page)
	tmp = page.css('div#factSheetHotelDetail > .factSheetHotelName').first.text
	tmp.match(/(BEST WESTERN( PLUS)?) (.*)/i)
	tmp = tmp.match(/(BEST WESTERN( PLUS)?) (.*)/i)
	{
		'name' => tmp[3],
		'type' => tmp[1],
	}
end

def address(page)
	tmp = page.css('div#factSheetHotelDetail > strong').children.select { |tag| tag.name == 'text'}.map { |tag| remove_spaces(tag.text) }
	foo = tmp.split(',').map { |s| remove_space(s) }
	{
		'street_address' => tmp[0],
		'city' => foo[0],
		'state' => foo[1],
		'zip' => foo[2],
		'phone' => tmp[3].gsub('Phone: ', '').gsub('/', '-'),
		'fax' => tmp[4].gsub('Fax: ', '').gsub('/', '-')
	}
end

def general_info(page, text, td_id)
  tmp = page.css('div#factSheetAmenities > div > table > tr > td')[td_id].text
  remove_spaces(tmp.gsub(text, ''))
end

def amenities(page)
	{
		'hotel_amenities' => amenities_each(page, 0),
		'guest_room_amenities' => amenities_each(page, 1),
		# 'area_information' => amenities_each(page, 2),
		# 'transportation' => amenities_each(page, 3),
		# 'directions' => amenities_each(page, 4),
		# 'restaurants' => amenities_each(page, 5)
	}
​
def amenities_each(page, li_id)
	page.css('ul')[li_id].css('li').map { |tag| tag.text }.join("; ")
end

def hotel_info(page)
  {
    'check_in' => general_info(page, 'Check in:', 0),
    'check_out' => general_info(page, 'Check Out:', 1),
    'hotel_rating' => general_info(page, 'Hotel Ratings:', 2),
    'pet_policy' => general_info(page, 'Pet Policy:', 3)
  }
  	.merge(name(page))
  	.merge(address(page))
  	.merge(amenities(page))


end





end
​