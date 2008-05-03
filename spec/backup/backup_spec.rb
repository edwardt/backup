# $Id$

require File.join(File.dirname(__FILE__), %w[ .. spec_helper ])
require File.join(File.dirname(__FILE__), %w[ backup_helper ])
require 'lib/backup.rb'

include EngineYard

describe Backup do
  
  include BackupHelper
  
  describe "when initialized" do
    it "should take 1 argument of a filename" do
      lambda { Backup.new }.should raise_error(ArgumentError)
      lambda { Backup.new("something") }.should raise_error("No such file found")
      File.should_receive(:file?).any_number_of_times.and_return(true)
      lambda { Backup.new("something") }.should_not raise_error
    end
    
    describe "and passed a valid filename" do
      before(:each) do
        File.should_receive(:file?).any_number_of_times.and_return(true)
        Dir.stub!(:glob).and_return( valid_backups )
        @backup = Backup.new("my.cnf")
      end
      
      it "should save a new file and delete all backups out of the threshold" do
        FileUtils.should_receive(:mv).exactly(1).times
        File.should_receive(:delete).with(/^my.cnf./).exactly(4).times.and_return(1)
        @backup.run
      end
      
      it "should not raise errors with zero current backups" do
        Dir.stub!(:glob).and_return( [] )
        FileUtils.should_receive(:mv).exactly(1).times
        File.should_receive(:delete).with(/^my.cnf./).exactly(0).times.and_return(1)
        @backup.run
      end
    
      describe "which returns a valid glob of files" do
      
        before(:each) do
          Dir.stub!(:glob).and_return( valid_backups )
          @backup = Backup.new("my.cnf")
          @backup.find_all_releases
        end
      
        it "should sort them into chronological order" do
          @backup.backups.should == valid_backups(9, :chronological)
        end
      
        it "should keep the 5 newest releases when creating a new backup" do
          @backup.keep_list.should == valid_backups(5, :chronological)
        end
        
        it "should keep the 3 newest releases when creating a new backup that has releases set to 3" do
          @backup.releases = 3
          @backup == valid_backups(3, :chronological)
        end
        
        it "should keep the 4 newest releases when creating a new backup that has a releases parameter of 4" do
          backup = Backup.new("my.cnf", 4)
          backup.find_all_releases
          backup.keep_list.should == valid_backups(4, :chronological)
        end
        
        it "should not delete old files if told not to" do
          backup = Backup.new("my.cnf", 4)
          FileUtils.should_receive(:mv).exactly(1).times
          backup.should_receive(:delete_old_backups).exactly(0).times
          backup.run(:no_delete)
        end
      
      end
      
      describe "which returns an invalid glob of files" do
      
        before(:each) do
          Dir.stub!(:glob).and_return( invalid_backups(3)  )
        end
      
        it "should handle incorrectly named files gracefully" do
          lambda { Backup.new("my.cnf") }.should_not raise_error(ArgumentError)
        end
      
      end
      
    end
    
  end
  
end

# EOF
