#module ActiveRecord
#  module ConnectionAdapters
#    class MysqlAdapter
#    private
#      def connect_with_local_infile
#        @connection.options(Mysql::OPT_LOCAL_INFILE, 1)
#        connect_without_local_infile
#      end
#      alias_method_chain :connect, :local_infile
#    end
#  end
#end
