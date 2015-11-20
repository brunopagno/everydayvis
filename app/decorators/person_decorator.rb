class PersonDecorator < Draper::Decorator
  delegate_all

  def display_name
    object.code? ? object.code : object.name
  end

end
