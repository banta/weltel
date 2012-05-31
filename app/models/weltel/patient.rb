# -*- encoding : utf-8 -*-
module Weltel
	class Patient
		include DataMapper::Resource

		# properties
		property(:id, Serial)
		property(:username, String, {:required => true, :unique => true, :length => 32})
		property(:study_number, String, {:unique => true, :length => 32})

		property(:created_at, DateTime)
		property(:updated_at, DateTime)

		# validations
		validates_length_of(:username, :within => 2..32)
		validates_format_of(:username, :with => /^\w*$/)

		validates_length_of(:study_number, {:within => 1..32, :allow_blank => true})
		validates_format_of(:study_number, {:with => /^\w*$/, :allow_blank => true})

		# associations
		belongs_to(:subscriber, Sms::Subscriber)
		has(n, :records, Weltel::Record, :constraint => :destroy)
		has(1, :last_record, Weltel::Record, :order => [:id.desc])

		# nested
		accepts_and_validates_nested_attributes_for(:subscriber)

		# instance methods
		#
		def create_record(date)
			records.create(:created_on => date)
		end

		# class methods
		#
		def self.active
			all(:subscriber => {:active => true})
		end

		#
		def self.last_record_created_before(date)
			all(:last_record => {:created_on.lt => date})
		end

		# search patients
		def self.search(page, per_page, search, order)
			patients = active
			patients = filter(active, search)
			patients = page_and_order(patients, page, per_page, order)
			patients
		end

		# create
		def self.create_by(params)
			create(params)
		end

		# update
		def self.update_by_id(id, params)
			patient = get!(id)
			patient.update(params)
			patient
		end

		# destroy
		def self.destroy_by_id(id)
			patient = get!(id)
			patient.subscriber.destroy
			patient.destroy
			patient
		end

	private
		# filter patients
		def self.filter(patients, search)
			if !search.nil?
				search += "%"
				patients =
					patients.all(:username.like => search) |
					patients.all(:study_number.like => search)
			end
			patients
		end

		# order and page patients
		def self.page_and_order(patients, page, per_page, order)
			patients.page(page, {:per_page => per_page, :order => order})
		end
	end
end
