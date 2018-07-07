module PortalCommunicator
  LOGIN_URL = "https://sps.acc.senshu-u.ac.jp/ActiveCampus/module/Login.php"
  MY_PAGE_URL = "https://sps.acc.senshu-u.ac.jp/ActiveCampus/module/MyPage.php"
  CHANGES_URL = "https://sps.acc.senshu-u.ac.jp/ActiveCampus/module/Kyuko.php"

  def can_login?(id, pass)
    browser = Mechanize.new
    page = nil
    browser.get(LOGIN_URL).form_with(name: "login_form") { |f|
      f.login = id
      f.passwd = pass
      f.mode = "Login"
      page = browser.submit(f)
    }
    logout(browser)
    result = (page.root.at(".login-error at") == nil)
  end

  def get_page(id, password, page)
    browser = login(id, password)
    browser.get(page).root
  end

  private

  def login(id, pass)
    browser = Mechanize.new
    page = nil
    browser.get(LOGIN_URL).form_with(name: "login_form") { |f|
      f.login = id
      f.passwd = pass
      f.mode = "Login"
      page = browser.submit(f)
    }
    browser
  end

  def logout(browser)
    form = browser.get(MY_PAGE_URL).forms[0]
    form.mode = "Logout"
    browser.submit(form)
  end

  module_function :can_login
  module_function :login
  module_function :logout
end
