---
layout: post
category: swing
folder: NewTabButton
title: JTabbedPane風のタブ配置をレイアウトマネージャーで変更
tags: [CardLayout, LayoutManager, JRadioButton, JTabbedPane]
author: aterai
pubdate: 2009-06-08T13:05:45+09:00
description: CardLayoutとJRadioButtonで作成したJTabbedPane風コンポーネントのタブ配置を自作レイアウトマネージャーで変更します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTQUU8wtpI/AAAAAAAAAfY/BJyG5weJ1VA/s800/NewTabButton.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2009/06/new-tab-button.html
    lang: en
comments: true
---
## 概要
`CardLayout`と`JRadioButton`で作成した`JTabbedPane`風コンポーネントのタブ配置を自作レイアウトマネージャーで変更します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTQUU8wtpI/AAAAAAAAAfY/BJyG5weJ1VA/s800/NewTabButton.png %}

## サンプルコード
<pre class="prettyprint"><code>class TabLayout implements LayoutManager, Serializable {
  private static final long serialVersionUID = 1L;
  private static final int TAB_WIDTH = 100;
  @Override public void addLayoutComponent(String name, Component comp) {
    /* not needed */
  }
  @Override public void removeLayoutComponent(Component comp) {
    /* not needed */
  }
  @Override public Dimension preferredLayoutSize(Container parent) {
    synchronized (parent.getTreeLock()) {
      Insets insets = parent.getInsets();
      int last = parent.getComponentCount() - 1;
      int w = 0;
      int h = 0;
      if (last &gt;= 0) {
        Component comp = parent.getComponent(last);
        Dimension d = comp.getPreferredSize();
        w = d.width;
        h = d.height;
      }
      return new Dimension(insets.left + insets.right + w,
                           insets.top + insets.bottom + h);
    }
  }

  @Override public Dimension minimumLayoutSize(Container parent) {
    synchronized (parent.getTreeLock()) {
      return new Dimension(100, 24);
    }
  }

  @Override public void layoutContainer(Container parent) {
    synchronized (parent.getTreeLock()) {
      int ncomponents = parent.getComponentCount();
      if (ncomponents == 0) {
        return;
      }
      //int nrows = 1;
      //boolean ltr = parent.getComponentOrientation().isLeftToRight();
      Insets insets = parent.getInsets();
      int ncols = ncomponents - 1;
      int lastw = parent.getComponent(ncomponents - 1).getPreferredSize().width;
      int width = parent.getWidth() - insets.left - insets.right - lastw;
      int h = parent.getHeight() - insets.top - insets.bottom;
      int w = width &gt; TAB_WIDTH * ncols ? TAB_WIDTH : width / ncols;
      int gap = width - w * ncols;
      int x = insets.left;
      int y = insets.top;
      for (int i = 0; i &lt; ncomponents; i++) {
        int cw = i == ncols ? lastw : w + (gap-- &gt; 0 ? 1 : 0);
        parent.getComponent(i).setBounds(x, y, cw, h);
        x += cw;
      }
    }
  }
  @Override public String toString() {
    return getClass().getName();
  }
}
</code></pre>

## 解説
上記のサンプルでは、以下のような`LayoutManager`を作成して`JRadioButton`を`JTabbedPane`風に並べています。

- 最後のタブ(タブ追加ボタン)の幅は常に固定
- 最後のタブの高さがタブエリアの高さ
- タブエリアの幅に余裕がある場合は、各タブ幅は`100px`で一定
- タブエリアの幅に余裕がない場合は、各タブ幅は均等
- タブを削除した場合、先頭タブにフォーカスが移動する
- 左の`JButton`(ダミー)は、タブエリアをラップする`JPanel(BorderLayout)`の`BorderLayout.WEST`に配置
- アイコンはランダム

<!-- dummy comment line for breaking list -->

## 参考リンク
- [XP Style Icons - Download](https://xp-style-icons.en.softonic.com/)
- [CardLayoutを使ってJTabbedPane風のコンポーネントを作成](https://ateraimemo.com/Swing/CardLayoutTabbedPane.html)

<!-- dummy comment line for breaking list -->

## コメント
- タブの切り替えは、`mouseClicked`ではなく、`mousePressed`した時に行うように変更。 -- *aterai* 2012-03-21 (水) 18:46:30

<!-- dummy comment line for breaking list -->
