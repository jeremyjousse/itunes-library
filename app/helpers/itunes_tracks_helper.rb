module ItunesTracksHelper
  def reference_track_has_year(reference_track)
    return 'has_year' if reference_track.reference_album.year.to_i > 0

    'doesnt_have_year'
  end
end
