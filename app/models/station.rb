class Station < ApplicationRecord
  has_many :trip_stations
  has_many :trips, through: :trip_stations
  has_one :population_spec, dependent: :destroy
  
  def name_with_code
    "#{name} (#{code})"
  end
  
  # html_data is from google maps page, 
  # content starting with <div jstcache="xxx" class="section-popular-times-container"
  # => inspect section-popular-times-container, edit as html and copy contents 
  def update_population_data(html_data)
    # Remove old population spec and create new one 
    create_population_spec
  
    # parse html 
    doc = Nokogiri::XML(html_data)
    
    # get strings ["79% busy at 4 pm.", ...]
    pop_per_hour_strings = doc.xpath("//div[contains(@class,'section-popular-times-bar')]/@aria-label").map{|i| i.value}

    week_days = %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday)   
    
    # 168 strings, group into 24 and match to day of week 
    # TODO: some check to ensure 168 items?
    pop_per_hour_strings.in_groups_of(24).each_with_index do |pop_string_group, index|
      # create population day for current set of 24 items
      # TODO: handle existing day (should not happen as each update should remove current population data completely)
      pop_day = PopulationDay.create(name: week_days[index], location: index)
      self.population_spec.population_days << pop_day 
      
      # tmp variable for type 2 processing 
      prev_hour_12 = 0
      
      # convert strings to population hour records 
      pop_string_group.each do |pop_string|
        # To retrieve and process data from string 
        # population string has two formats:  
        # 1: "79% busy at 4 pm."
        # 2: "Currently 65% busy, usually 80% busy."
        # determine format 
        pop_str_split = pop_string.split(', ')
        if pop_str_split.length == 2 
          # process type 2 string 
          components = pop_str_split[1].split
          percent = components[1].chop # chop to remove % sign 
          hour_24    = DateTime.strptime(prev_hour_12, '%l%P.') + 1.hour # add an hour to prev_hour_12 for correct hour 
        else 
          # process type 1 string 
          components = pop_str_split[0].split
          percent    = components[0].chop # chop to remove % sign 
          hour_12    = components[3] + components[4]
          prev_hour_12 = hour_12 # saving this for type 2 processing 
          hour_24    = DateTime.strptime(hour_12, '%l%P.')                
        end
        
        # add population hours to newly created population day 
        pop_hour = PopulationHour.create(
                    hour: hour_24.hour, population_percent: percent)                    
        pop_day.population_hours << pop_hour 
      end       
    end

    self.population_spec 
  end
  
  
  def create_population_spec
    self.population_spec.destroy if self.population_spec
    reload 
    self.population_spec = PopulationSpec.create
  end
end
