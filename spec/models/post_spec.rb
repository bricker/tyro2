require 'spec_helper'

describe Post do
  it "validates presence of title body user_id show_id" do
    post = Post.new
    %w[title body user_id show_id].each do |attr|
      post.should have(1).error_on(attr)
    end
  end

  it "sorts by created_at DESC" do
    user = Factory(:user)
    show = Factory(:show)
    post1 = Factory(:post, :created_at => 2.weeks.ago, :show => show, :user => user)
    post2 = Factory(:post, :created_at => Time.zone.now, :show => show, :user => user)
    Post.last(2).should eq([post2, post1])
  end
end
    
