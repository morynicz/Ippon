json.admins do
  json.array! @admins, partial: 'auth/user', as: :user
end
json.users do
  json.array! @users, partial: 'auth/user', as: :user
end
