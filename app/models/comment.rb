class Comment < ActiveRecord::Base
  belongs_to :article
  validates :commenter, :body,  presence: true,
                    length: { minimum: 1 }
end
