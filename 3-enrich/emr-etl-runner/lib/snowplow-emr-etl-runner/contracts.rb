# Copyright (c) 2012-2015 Snowplow Analytics Ltd. All rights reserved.
#
# This program is licensed to you under the Apache License Version 2.0,
# and you may not use this file except in compliance with the Apache License Version 2.0.
# You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the Apache License Version 2.0 is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.

# Author::    Alex Dean (mailto:support@snowplowanalytics.com)
# Copyright:: Copyright (c) 2012-2015 Snowplow Analytics Ltd
# License::   Apache License Version 2.0

require 'contracts'

module Snowplow
  module EmrEtlRunner

    include Contracts

    CompressionFormat = lambda { |s| %w(NONE GZIP).include?(s) }
    VolumeTypes = lambda { |s| %w(standard gp2 io1).include?(s) }
    PositiveInt = lambda { |i| i.is_a?(Integer) && i > 0 }

    # The Hash containing assets for Hadoop.
    AssetsHash = ({
      :enrich  => String,
      :shred   => String
      })

    # The Hash of the CLI arguments.
    ArgsHash = ({
      :debug => Bool,
      :resume_from => Maybe[String]
      })

    # The Hash containing the buckets field from the configuration YAML
    BucketHash = ({
      :assets => String,
      :jsonpath_assets => Maybe[String],
      :log => String,
      :raw => ({
        :in => ArrayOf[String],
        :processing => String,
        :archive => String
        }),
      :enriched => ({
        :good => String,
        :bad => String,
        :errors => Maybe[String],
        :archive => Maybe[String]
        }),
      :shredded => ({
        :good => String,
        :bad => String,
        :errors => Maybe[String],
        :archive => Maybe[String]
        })
      })

    # The Hash containing the storage targets to load
    TargetHash = ({
      :name => String,
      :type => String,
      :host => String,
      :database => String,
      :port => Num,
      :ssl_mode => Maybe[String],
      :table => String,
      :username => Maybe[String],
      :password => Maybe[String],
      :es_nodes_wan_only => Maybe[Bool],
      :maxerror => Maybe[Num],
      :comprows => Maybe[Num]
      })

    # The Hash containing the configuration for a core instance using EBS.
    CoreInstanceEbsHash = ({
      :volume_size => PositiveInt,
      :volume_type => VolumeTypes,
      :volume_iops => Maybe[PositiveInt],
      :ebs_optimized => Maybe[Bool]
      })

    # The Hash containing effectively the configuration YAML.
    ConfigHash = ({
      :aws => ({
        :access_key_id => String,
        :secret_access_key => String,
        :s3 => ({
          :region => String,
          :buckets => BucketHash
          }),
        :emr => ({
          :ami_version => String,
          :region => String,
          :jobflow_role => String,
          :service_role => String,
          :placement => Maybe[String],
          :ec2_subnet_id => Maybe[String],
          :ec2_key_name => String,
          :bootstrap => Maybe[ArrayOf[String]],
          :software => ({
            :hbase => Maybe[String],
            :lingual => Maybe[String]
            }),
          :jobflow => ({
            :master_instance_type => String,
            :core_instance_count => Num,
            :core_instance_type => String,
            :core_instance_ebs => Maybe[CoreInstanceEbsHash],
            :task_instance_count => Num,
            :task_instance_type => String,
            :task_instance_bid => Maybe[Num]
            }),
          :additional_info => Maybe[String],
          :bootstrap_failure_tries => Num
          }),
        }),
      :collectors => ({
        :format => String,
        }),
      :enrich => ({
        :job_name => String,
        :versions => ({
          :hadoop_enrich => String,
          :hadoop_shred => String
          }),
        :continue_on_unexpected_error => Bool,
        :output_compression => CompressionFormat
        }),
      :storage => ({
        :download => ({
          :folder => Maybe[String]
          }),
        :targets => ArrayOf[TargetHash]
        }),
      :monitoring => ({
        :tags => HashOf[Symbol, String],
        :logging => ({
          :level => String
          }),
        :snowplow => Maybe[{
          :method => String,
          :collector => String,
          :app_id => String
          }]
        })
      })

    # The Array (Tuple3) containing the CLI arguments, configuration YAML, and configuration JSONs
    ArgsConfigEnrichmentsResolverTuple = [String, ArgsHash, Maybe[ConfigHash], ArrayOf[String], String]

  end
end
