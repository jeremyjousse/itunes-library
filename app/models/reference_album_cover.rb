class ReferenceAlbumCover < ActiveRecord::Base
   mount_uploader :cover, ReferenceCoverUploader
   belongs_to :reference_album
end