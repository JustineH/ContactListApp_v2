require_relative 'contact'
require_relative 'database'
require 'pg'
require 'pp'
require 'pry'


def self.response_program
  case ARGV.first
    when "create"
      puts "Type the contact's full name."
      name = STDIN.gets.chomp
      puts "Type the contact's email address."
      email = STDIN.gets.chomp
      "#{new_contact(name, email)}"
    when "all"
      puts "Here is the list of all the contacts: "
      "#{list_contacts}"
    when "show"
      puts "Type in the ID of the contact you would like retrieved."
      id = STDIN.gets.chomp
      puts "Here is the contact you searched for: #{show_contact(id)}"
    when "search" 
      puts "Type in the search term of the contact you would like retrieved."
      term = STDIN.gets.chomp
      puts "Here is your search result: #{search_contact(term)}"
    when "delete" 
      puts "Type in the ID of the contact you would like to delete."
      id = STDIN.gets.chomp
      puts "#{delete_contact(id)}"
    else
      puts "Sorry, invalid input!"
      puts "Here is a list of available commands:"
      puts "create - Create a new contact"
      puts "all - List all contacts"
      puts "show - Show a contact"
      puts "search - Search contacts"
      puts "delete - Delete a contact by id"
  end

  puts 'Closing the connection...'
  CONN.close
  puts 'DONE'
end

  def self.list_contacts
    Contact.all.each do |contact|
      pp "ID ##{contact.id}: #{contact.name}, #{contact.email}"
    end
  end 

  def self.new_contact(name, email)
    contact = Contact.create(name, email)
    pp "#{contact.name} has been added."
  end

  def self.show_contact(id)
    contact = Contact.find(id)
    pp "ID ##{contact.id}: #{contact.name}, #{contact.email}"
  end

  def self.search_contact(term)
    contact = Contact.search('name', term)
  end

  def delete_contact(id)
    contact = Contact.find(id)
    if contact 
      contact.destroy 
      pp "#{contact.name} whose ID is ##{contact.id} has been deleted from the database"
    else
      pp "Contact not found."
    end
  end


response_program
 