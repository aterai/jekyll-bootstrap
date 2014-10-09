---
layout: post
category: swing
folder: LayoutAnimation
title: LayoutManagerを使ってパネルの展開アニメーションを行う
tags: [LayoutManager, Animation, BorderLayout, JTree, JPanel]
author: aterai
pubdate: 2010-11-22T14:41:14+09:00
description: パネルの展開・収納をアニメーションで行うLayoutManagerを作成します。
comments: true
---
## 概要
パネルの展開・収納をアニメーションで行う`LayoutManager`を作成します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTO_fTHG-I/AAAAAAAAAdQ/9SHzG18aVW0/s800/LayoutAnimation.png %}

## サンプルコード
<pre class="prettyprint"><code>private javax.swing.Timer animator = null;
private boolean isHidden = true;
private final JPanel controls = new JPanel(new BorderLayout(5, 5) {
  private int controlsHeight = 0;
  private int controlsPreferredHeight = 0;
  @Override public Dimension preferredLayoutSize(Container target) {
    Dimension ps = super.preferredLayoutSize(target);
    controlsPreferredHeight = ps.height;
    if(animator!=null) {
      if(isHidden) {
        if(controls.getHeight()&lt;controlsPreferredHeight) controlsHeight += 5;
      }else{
        if(controls.getHeight()&gt;0) controlsHeight -= 5;
      }
      if(controlsHeight&lt;=0) {
        controlsHeight = 0;
        animator.stop();
      }else if(controlsHeight&gt;=controlsPreferredHeight) {
        controlsHeight = controlsPreferredHeight;
        animator.stop();
      }
    }
    ps.height = controlsHeight;
    return ps;
  }
});
private Action makeShowHideAction() {
  return new AbstractAction("Show/Hide Search Box") {
    @Override public void actionPerformed(ActionEvent e) {
      if(animator!=null &amp;&amp; animator.isRunning()) return;
      isHidden = controls.getHeight()==0;
      animator = new javax.swing.Timer(5, new ActionListener() {
        @Override public void actionPerformed(ActionEvent e) {
          controls.revalidate();
        }
      });
      animator.start();
    }
  };
}
</code></pre>

## 解説
上記のサンプルでは、`LayoutManager#preferredLayoutSize(...)`をオーバーライドして、パネルの高さを更新するアニメーションを行っています。

- - - -
内部の`JTree`の高さを縮小せずに、重ねる状態で検索パネルを表示したい場合は、`BorderLayout`ではなく、`OverlayLayout`を[JTextAreaをキャプションとして画像上にスライドイン](http://terai.xrea.jp/Swing/EaseInOut.html)のように使用する方法があります。

## 参考リンク
- [JTreeのノードを検索する](http://terai.xrea.jp/Swing/SearchBox.html)
    - このサンプルで省略した、実際に`JTree`のノードを検索するコードはこちらにあります。
- [JTextAreaをキャプションとして画像上にスライドイン](http://terai.xrea.jp/Swing/EaseInOut.html)

<!-- dummy comment line for breaking list -->

## コメント
