require 'spec_helper'

describe "Common Gollum Git Interface" do
  
  before(:each) do
    @repo = Gollum::Git::Repo.new(fixture('dot_bare_git'), :is_bare => true)
  end
  
  describe Gollum::Git::Actor do
    before(:each) do
      @actor = Gollum::Git::Actor.new("Tom Werner", "tom@example.com")
    end
  
    it "should have accessors for name and email" do
      @actor.should respond_to(:name)
      @actor.should respond_to(:email)
    end
  
    it "should have an output method" do
      @actor.should respond_to(:output)
    end
  
  end

  describe Gollum::Git::Blob do
    before(:each) do
      @blob = @repo.head.commit.tree.blobs.first
    end
  
    it "should have a name" do
      @blob.should respond_to(:name)
    end
  
    it "should have the extension for symlinks" do
      @blob.should respond_to(:is_symlink)
      @blob.should respond_to(:symlink_target).with(1).argument
    end
  end

  describe Gollum::Git::Commit do
    before(:each) do
      @commit = @repo.commits.first
    end
  
    it "should have an id, an author and a message" do
      @commit.should respond_to(:id)
      @commit.should respond_to(:author)
      @commit.should respond_to(:message)
    end
  
    it "should return a Gollum::Git::Actor object for author" do
      @commit.author.should be_a Gollum::Git::Actor
    end
  
    it "should print the id with to_s" do
      @commit.to_s.should == @commit.id
    end
  
    it "should return a single Gollum::Git::Tree object for Commit#tree" do
      @commit.tree.should be_a Gollum::Git::Tree
    end
  end

  describe Gollum::Git::Git do
    before(:each) do
      @git = @repo.git
    end
  
    it "should have a grep method" do
      @git.should respond_to(:grep)
    end

    it "should have an rm method" do
      @git.should respond_to(:rm)
    end  
  
    context "porcelain API" do
      it "should have a rev_list method" do
        @git.should respond_to(:rev_list).with(2).arguments
      end
  
      it "should have the ls_files method" do
        @git.should respond_to(:ls_files).with(2).arguments
      end
    
      it "should have a checkout method" do
        @git.should respond_to(:checkout).with(3).arguments
      end
    
      it "should have an apply_path method" do
        (1..3).each{|i| @git.should respond_to(:apply_patch).with(i).arguments}
      end
    
      it "should have a native method" do
        @git.should respond_to(:native)
      end
    
      it "should have a cat_file method" do
        @git.should respond_to(:cat_file).with(2).arguments
      end
    
      it "should have a refs method" do
        @git.should respond_to(:refs).with(2).arguments
      end

    end
  
  end

  describe Gollum::Git::Index do
    before(:each) do
      @index = @repo.index
    end
  
    it "should respond to add, delete and commit" do
      @index.should respond_to(:add).with(2).arguments
      @index.should respond_to(:delete).with(1).argument
      @index.should respond_to(:commit).with(1).argument
      @index.should respond_to(:commit).with(5).arguments
    end
  
    it "should return a Gollum::Git::Tree for Index#tree" do
      @index.tree.should be_a Gollum::Git::Tree
    end
  
    it "should have a read_tree method" do
      @index.should respond_to(:read_tree).with(1).argument
    end
  
    it "should load the current tree with Index#read_tree" do
      @index.current_tree.should be_nil 
      @index.read_tree(@repo.head.commit.id)
      @index.current_tree.should_not be_nil
    end
  
    it "should return a Gollum::Git::Tree for Index#current_tree" do
      @index.read_tree(@repo.head.commit.id)
      @index.current_tree.should be_a Gollum::Git::Tree
    end
  
  end

  describe Gollum::Git::Ref do
    before(:each) do
      @ref = @repo.head
    end
  
    it "should have a name method" do
      @ref.should respond_to(:name)
    end
  
    it "should return a Gollum::Git::Commit for Ref#commit" do
      @ref.commit.should be_a Gollum::Git::Commit
    end
  end

  describe Gollum::Git::Repo do
  
    it "should have a path method" do
      @repo.should respond_to(:path)
    end
  
    it "should return a Gollum::Git::Git object for Repo#git" do
      @repo.git.should be_a Gollum::Git::Git
    end
  
    it "should return an array of Gollum::Git::Commit objects for Repo#commits" do
      @repo.commits.should be_a Array
      @repo.commits.each{|commit| commit.should be_a Gollum::Git::Commit}
    end
  
    it "should return a Gollum::Git::Ref object for Repo#head" do
      @repo.head.should be_a Gollum::Git::Ref
    end
  
  end

  describe Gollum::Git::Tree do
    before(:each) do
      @repo.index.read_tree(@repo.head.commit.id)
      @tree = @repo.index.current_tree
    end
  
    it "should return an array of Gollum::Git::Blob objects for Tree#blobs" do
      @tree.blobs.should be_a Array
      @tree.blobs.each{|blob| blob.should be_a Gollum::Git::Blob}
    end
  end
end