module Eventable
  extend ActiveSupport::Concern

  included do

    after_create do |object|
      $eventer.publish("#{object.class.name.downcase}.create", object.to_json)
    end

    after_save do |object|
      $eventer.publish("#{object.class.name.downcase}.save", object.to_json)
    end

    after_destroy do |object|
      $eventer.publish("#{object.class.name.downcase}.destroy", object.to_json)
    end

  end

end
