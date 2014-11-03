module Eventable
  extend ActiveSupport::Concern

  included do

    after_create do |object|
      event = Redis.new()
      event.publish("#{object.class.name.downcase}.create", object.id)
    end

    after_save do |object|
      event = Redis.new()
      event.publish("#{object.class.name.downcase}.save", object.id)
    end

    after_destroy do |object|
      event = Redis.new()
      event.publish("#{object.class.name.downcase}.destroy", object.id)
    end

  end

end
