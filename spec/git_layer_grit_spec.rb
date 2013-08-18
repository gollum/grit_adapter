require 'spec_helper'

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
    @repo = Gollum::Git::Repo.new(fixture('dot_bare_git'), :is_bare => true)
    @blob = @repo.commits.first.tree.blobs.first
  end
  
  it "should have a name" do
    @blob.should respond_to(:name)
  end
  
  it "should" do
  end
end

describe Gollum::Git::Commit do
  before(:each) do
    @repo = Gollum::Git::Repo.new(fixture('dot_bare_git'), :is_bare => true)
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
    @repo = Gollum::Git::Repo.new(fixture('dot_bare_git'), :is_bare => true)
    @git = @repo.git
  end
  
  it "should have a rev_list method" do
    @git.should respond_to(:rev_list)
  end
end

describe Gollum::Git::Index do
  before(:each) do
  end
  
  it "should respond to add, delete and commit" 
  
  it "should return a Gollum::Git::Tree for Index#tree"
  
  it "should return a Gollum::Git::Tree for Index#current_tree"
  
end

describe Gollum::Git::Ref do
  before(:each) do
    @repo = Gollum::Git::Repo.new('/tmp/testert-bare', :is_bare => true)
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
  before(:each) do
     @repo = Gollum::Git::Repo.new(fixture('dot_bare_git'), :is_bare => true)
  end
  
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
  end
end