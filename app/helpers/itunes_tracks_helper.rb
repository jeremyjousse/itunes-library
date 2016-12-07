module ItunesTracksHelper
  def reference_track_has_year(reference_track)
    return 'has_year' if reference_track.reference_album.year.to_i > 0

    'doesnt_have_year'
  end

  def static_rating(rating)
    closed = false
    output = '<span class="yellow">'
    5.times do |time|
      if ((1 + time) * 20) > rating.to_i && closed == false
        closed = true.to_s + time.to_s
        output += '</span>'
      end
      output += content_tag(:span, '', class: 'glyphicon glyphicon-star')
    end
    output += '</span>' if closed == false
    output
  end

  def active_rating(rating, temp_rating)
    output = '<span class="active-rating">'
    output += static_rating(rating)
    output + '</span>'
  end
end
