FactoryBot.define do
  factory :user do
    token { 'valid_token' } 
    purchase_count { 3 }
  end
end