# ~*~ encoding: utf-8 ~*~

require 'grit'

module Gollum
  module Git
    
    class Actor
      
      attr_accessor :name, :email
      
      def initialize(name, email)
        @name = name
        @email = email
        @actor = Grit::Actor.new(name, email)
      end
      
      def output(time)
        @actor.output(time)
      end
      
    end
    
    class Blob
      def self.create(repo, options)
        #Grit::Blob.create(repo, :id => @sha, :name => name, :size => @size, :mode => @mode)
        blob = Grit::Blob.create(repo, options)
        self.new(blob)
      end
      
      def initialize(blob)
        @blob = blob
      end
      
      def data
        @blob.data
      end
      
      def name
        @blob.name
      end
      
      def mime_type
        @blob.mime_type
      end
      
      def is_symlink
        @blob.is_symlink
      end

      def symlink_target(base_path = nil)
        @blob.symlink_target(base_path)
      end
    end
    
    class Commit
      
      def initialize(commit)
        @commit = commit
      end
      
      def id
        @commit.id
      end
      alias_method :sha, :id
      
      def to_s
        @commit.id
      end
      
      def author
        author = @commit.author
        Gollum::Git::Actor.new(author.name, author.email)
      end
      
      def message
        @commit.message
      end
      
      def tree
        Gollum::Git::Tree.new(@commit.tree)
      end
      
      # Grit::Commit.list_from_string(@wiki.repo, log)
      def self.list_from_string(repo, log)
        Grit::Commit.list_from_string(repo, log)
      end
      
    end
    
    # Note that in Grit, the methods grep, rm, checkout, ls_files
    # are all passed to native via method_missing. Hence the uniform
    # method signatures.
    class Git
    
      def initialize(git)
        @git = git
      end
      
      def exist?
        @git.exist?
      end
      
      def grep(options={}, *args, &block)
        @git.grep(options, *args, &block)
      end
      
      # git.rm({'f' => true}, '--', path)
      def rm(options={}, *args, &block)
        @git.rm(options, *args, &block)
      end
      
      # git.checkout({}, 'HEAD', '--', path)
      def checkout(options={}, *args, &block)
        @git.checkout(options, *args, &block)
      end
      
      def rev_list(options, *refs)
        @git.rev_list(options, *refs)
      rescue Grit::GitRuby::Repository::NoSuchShaFound
        raise Gollum::Git::NoSuchShaFound
      end
      
      def ls_files(options={}, *args, &block)
        @git.ls_files(options, *args, &block)
      end
      
      def apply_patch(options={}, head_sha=nil, patch=nil)
        @git.apply_patch(options, head_sha, patch)
      end
      
      # @wiki.repo.git.native "log", options, @wiki.ref, "--", @path
      def native(cmd, options = {}, *args, &block)
        @git.native(cmd, options, *args, block)
      end
      
      # @repo.git.cat_file({:p => true}, sha)
      def cat_file(options, sha)
        @git.cat_file(options, sha)
      end
      
      def refs(options, prefix)
        @git.refs(options, prefix)
      end
      
    end
    
    class Index
      
      def initialize(index)
        @index = index
        @tree = Gollum::Git::Tree.new(@index.tree)
        @current_tree = nil
      end
      
      def delete(path)
        @index.delete(path)
      end
      
      def add(path, data)
        @index.add(path, data)
      end
      
      # index.commit(@options[:message], parents, actor, nil, @wiki.ref)
      def commit(message, parents = nil, actor = nil, last_tree = nil, head = 'master')
        @index.commit(message, parents, actor, last_tree, head)
      end
      
      def tree
        @tree ||= Gollum::Git::Tree.new(@index.tree)
      end
      
      def read_tree(id)
        @index.read_tree(id)
        @current_tree = Gollum::Git::Tree.new(@index.current_tree)
      end
      
      def current_tree
        @current_tree
      end
      
    end
    
    class Ref
      def initialize(ref)
        @ref = ref
      end
      
      def name
        @ref.name
      end
      
      def commit
        Gollum::Git::Commit.new(@ref.commit)
      end
            
    end
    
    class Repo
      
      def initialize(path, options)
        @repo = Grit::Repo.new(path, options)
      end
      
      def self.init(path, git_options = {}, repo_options = {})
        Grit::Repo.init(path, git_options, repo_options)
        self.new(path, {:is_bare => false})
      end
      
      def self.init_bare(path, git_options = {}, repo_options = {})
        Grit::Repo.init_bare(path, git_options, repo_options)
        self.new(path, {:is_bare => true})
      end
      
      def bare
        @repo.bare
      end
      
      def config
        @repo.config
      end
      
      def git
        @git ||= Gollum::Git::Git.new(@repo.git)
      end
      
      def commit(id)
        commit = @repo.commit(id)
        return nil if commit.nil?
        Gollum::Git::Commit.new(@repo.commit(id))
      end
      
      def commits(start = 'master', max_count = 10, skip = 0)
        @repo.commits(start, max_count, skip).map{|commit| Gollum::Git::Commit.new(commit)}
      end
      
      # @wiki.repo.head.commit.sha
      # Grit has Head class somewhere, but where?
      def head
        Gollum::Git::Ref.new(@repo.head)
      end
      
      def index
        Gollum::Git::Index.new(@repo.index)
      end
      
      def log(commit = 'master', path = nil, options = {})
        @repo.log(commit, path, options)
      end
      
      def path
        @repo.path
      end
      
      def update_ref(head, commit_sha)
        @repo.update_ref(head, commit_sha)
      end

      
    end
    
    class Tree
      
      def initialize(tree)
        @tree = tree
      end
      
      def keys
        @tree.keys
      end
      
      def [](i)
        @tree[i]
      end
      
      def id
        @tree.id
      end
      
      # if index.current_tree && tree = index.current_tree / (@wiki.page_file_dir || '/')
      def /(file)
        @tree.send(:/, file) 
      end
      
      def blobs
        @tree.blobs.map{|blob| Gollum::Git::Blob.new(blob) }
      end
    end
    
    class NoSuchShaFound < StandardError
    end
    
  end
end

# Monkey patching Grit's Blob class (taken from grit_ext.rb)
module Grit
  class Blob
    def is_symlink
      self.mode == 0120000
    end

    def symlink_target(base_path = nil)
      target = self.data
      new_path = File.expand_path(File.join('..', target), base_path)

      if File.file? new_path
        return new_path
      end
    end

    nil
  end
end