class RenameImageUrlToPostImageInPosts < ActiveRecord::Migration[7.1]
  def change
    rename_column :posts, :image_url, :post_image
  end
end
