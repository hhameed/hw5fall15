# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie);
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  all('input[type="checkbox"]').each {|ch| uncheck(ch[:id]) }
  arg1.split(', ').each do |rating|
    check('ratings_'+rating)
  end
  click_button('ratings_submit')
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
  ratings = arg1.split(', ')
  result=true
  all("tbody tr").each do |tr|
    txt = tr.all('td')[1].text
    result &&= ratings.include?(txt)
  end
  expect(result).to be_truthy
  expect(all("tbody tr").count).to eq(Movie.where(:rating=>ratings).count())
end

Then /^I should see all of the movies$/ do
  result = all("tbody tr").count
  expect(result).to eq(10)
end


When /^I have opted to sort movies by: "(.*?)"$/ do |arg1|
  sort_by = arg1.downcase.gsub(' ', '_') + '_header'
  click_link(sort_by)
  all("tbody tr").each do |tr|
    txt = tr.all('td')[0].text
    result &&= ratings.include?(txt)
  end
end

Then /^I should see "(.*?)" before "(.*?)"$/ do |movie1,movie2|
  result = /#{movie1}.*#{movie2}/m =~ page.body
  expect(result).to be_truthy
end
