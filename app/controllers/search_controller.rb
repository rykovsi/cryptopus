# $Id$

# Copyright (c) 2007 Puzzle ITC GmbH. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

class SearchController < ApplicationController

  # GET /search
  def index

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def account
    term = params[:search_string]

    accounts = Account.where("accountname like ?", "%#{term}%").joins(:group)

    decrypt_accounts(accounts)

    render json: accounts
  end

private

  def decrypt_accounts(accounts)
    accounts.each do |a|
      team = a.group.team
      a.username = CryptUtils.decrypt_blob a.username, get_team_password(team)
      a.password = CryptUtils.decrypt_blob a.password, get_team_password(team)
    end
  end

end