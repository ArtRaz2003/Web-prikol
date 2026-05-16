module UsersHelper
  # Возвращает Gravatar для данного пользователя
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar", style: "border-radius: 50%; max-width: 100px;")
  end
end
