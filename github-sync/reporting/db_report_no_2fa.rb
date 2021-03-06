# Copyright 2015 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'rubygems'
require 'yaml'
require_relative 'db_reporter'

class No2faDbReporter < DbReporter

  def name()
    return "Members Without 2FA"
  end

  def report_class()
    return 'user-report'
  end

  def describe()
    return "This report shows which of your organization members have not configured two-factor authentication for their account. "
  end

  def db_columns()
    return [ ['login', 'member'] ]
  end

  def db_report(context, org, sync_db)
    no2fa=sync_db.execute("SELECT DISTINCT(m.login) FROM member m, repository r, team_to_member ttm, team_to_repository ttr WHERE m.two_factor_disabled='true' AND m.id=ttm.member_id AND ttm.team_id=ttr.team_id AND ttr.repository_id=r.id AND r.org=?", [org])
    text = ''
    no2fa.each do |row|
      text << "  <reporting class='user-report' type='No2faDbReporter'>#{row[0]}</reporting>\n"
    end
    return text
  end

end
