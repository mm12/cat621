# Manually create posts and add them to the database.
# Post information is imported from a CSV file, `insertions.csv`.
require 'csv'

# for each post in the CSV file, create a post
CSV.foreach('db/insertions.csv', headers: true) do |row|
  post = Post.find_or_create_by(md5: row['md5']) do |p|
    p.update(tag_string: row['tags'].to_s) unless p.tag_string.present?
    p.update(source: row['id']) unless p.source.present?
    p.update(description: row['description']) unless p.description.present?
    p.update(md5: row['md5']) unless p.md5.present?
    p.update(file_ext: 'jpg') unless p.file_ext.present?
    p.update(uploader_id: 1) unless p.uploader_id.present?
    p.update(file_size: 1) # unless p.file_size.present?
    p.update(uploader_ip_addr:  IPAddr.new) unless p.uploader_ip_addr.present?
    p.update(created_at: Time.now) unless p.created_at.present?
    p.update(updated_at: Time.now) unless p.updated_at.present?
    p.update(image_width: 1) # unless p.image_width.present?
    p.update(image_height: 1) # unless p.image_height.present?
  end 

  # if post.save
  #   puts "Created post with ID #{post.id} and tags '#{post.tag_string}'"
  # else
  #   puts "Failed to create post: #{post.errors.full_messages.join(', ')}"
  # end
end