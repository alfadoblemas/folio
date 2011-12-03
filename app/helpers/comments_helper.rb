module CommentsHelper

  def suscribe_users(company_users, comment)
    users_array = company_users.to_a
    dom = []
    (0..2).each {|n| dom[n] = "<td>"}
    users_array.each_with_index do |user, index|
      id = "comment[notify_account_users][#{user.id}]"
      status = comment.notify_account_users[user.id]
      dom[index%3] << "#{check_box_tag id, '', status} #{user.name}<br/>"
    end
    (0..2).each {|n| dom[n] << "</td>"}
    result = dom.join("")
    result[0] = "<tr><"
    result << "</tr>"
    result
  end

end
