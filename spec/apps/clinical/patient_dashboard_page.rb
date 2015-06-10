class Clinical::PatientDashboardPage < Page

  TREATMENT_SECTION = "#dashboard-treatments"

    def verify_current_dashboard(name)
        dashboard = find('.dashboard a', :text => name, :match => :prefer_exact).parent
        expect(dashboard).to have_selector('.tab-selected')
    end

    def add_dashboard(name)
        find('#addDashboardButton').click
        find('.unOpenedDashboard', :text => name, :match => :prefer_exact).click
        wait_for_overlay_to_be_hidden
    end

    def navigate_to_dashboard(name)
        find(".dashboard a", :text => name, :match => :prefer_exact).click
        wait_for_overlay_to_be_hidden
    end

    def verify_visit_vitals_info(vitals)
        vitals_section = find('.dashboard-section h2', :text => 'Vitals').parent
        expect(vitals_section).to have_content("BMI #{vitals[:bmi]}") if vitals.has_key? :bmi
        expect(vitals_section).to have_content("BMI STATUS #{vitals[:bmi_status]}") if vitals.has_key? :bmi_status
        expect(vitals_section).to have_content("HEIGHT #{vitals[:height]}") if vitals.has_key? :height
        expect(vitals_section).to have_content("WEIGHT #{vitals[:weight]}") if vitals.has_key? :weight
    end

    def start_consultation
        find("a", :text => 'Consultation', :match => :prefer_exact).click
    end

    def verify_existing_drugs(sections)
      sections.each do |section|
        table = page.find(TREATMENT_SECTION, text: section['visit_date'])
        section['drugs'].each do |drug|
          expect(table).to have_content(drug)
        end
      end
    end

    def navigate_to_all_treatments_page
      find('h2', :text =>'Treatments').click
    end

    def navigate_to_visit_page(visit_date)
      find("a", :text=>visit_date, :match => :prefer_exact).click
    end

    def navigate_to_current_visit
      find(".visits i[title='Current Visit']").click
      sleep 2
      wait_for_overlay_to_be_hidden
    end

    def verify_new_drugs(*drugs)
      verify_drug_details(TREATMENT_SECTION, *drugs)
    end

    def verify_patient_profile_section(name)
      # todo: add more verification
      patient_section = find("#patient_information")
      expect(patient_section).to have_content(name)
    end

  def verify_radiology_section(radiology_image_concepts)
    expect(page).to have_selector('.dashboard-radiology-section .radiology-doc-item', :count=>radiology_image_concepts.length)
    radiology_image_concepts.each_with_index { |radiology_image_item, index|
      expect(find(".dashboard-radiology-section .radiology-doc-item:nth-of-type(#{index+1}) a", :visible => true).text).to eq(radiology_image_item[:concept_name])
      image_count = radiology_image_item[:image_count]
      if(image_count)
      expect(find(".dashboard-radiology-section .radiology-doc-item:nth-of-type(#{index+1}) span", :visible => true).text).to eq("(#{image_count})")
      end
    }
  end

end