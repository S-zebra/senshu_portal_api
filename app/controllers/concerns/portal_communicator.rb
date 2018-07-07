module PortalCommunicator
  LOGIN_URL = "https://sps.acc.senshu-u.ac.jp/ActiveCampus/module/Login.php"
  MY_PAGE_URL = "https://sps.acc.senshu-u.ac.jp/ActiveCampus/module/MyPage.php"
  CHANGES_URL = "https://sps.acc.senshu-u.ac.jp/ActiveCampus/module/Kyuko.php"

  def can_login?(id, pass)
    browser = Mechanize.new
    page = browser.get(LOGIN_URL)
    res = nil
    page.form_with(name: "login_form") { |f|
      f.login = id
      f.passwd = pass
      f.mode = "Login"
      res = browser.submit(f)
    }
    puts res.root
    res.root.at(".login-error at") == nil
  end

  module_function :can_login?
end
