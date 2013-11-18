---
layout: post
title: JTabbedPane風のタブ配置をレイアウトマネージャーで変更
category: swing
folder: NewTabButton
tags: [CardLayout, LayoutManager, JRadioButton, JTabbedPane]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-06-08

## JTabbedPane風のタブ配置をレイアウトマネージャーで変更
`CardLayout`と`JRadioButton`で作成した`JTabbedPane`風コンポーネントのタブ配置を自作レイアウトマネージャーで変更します。

{% download %}

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTQUU8wtpI/AAAAAAAAAfY/BJyG5weJ1VA/s800/NewTabButton.png)

### サンプルコード
<pre class="prettyprint"><code>class TabLayout implements LayoutManager, java.io.Serializable {
  @Override public void addLayoutComponent(String name, Component comp) {}
  @Override public void removeLayoutComponent(Component comp) {}
  @Override public Dimension preferredLayoutSize(Container parent) {
    synchronized (parent.getTreeLock()) {
      Insets insets = parent.getInsets();
      int last = parent.getComponentCount()-1;
      int w = 0, h = 0;
      if(last&gt;=0) {
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
      Insets insets = parent.getInsets();
      int ncomponents = parent.getComponentCount();
      int nrows = 1;
      int ncols = ncomponents-1;
      //boolean ltr = parent.getComponentOrientation().isLeftToRight();

      if (ncomponents == 0) {
        return;
      }
      int lastw = parent.getComponent(ncomponents-1).getPreferredSize().width;
      int width = parent.getWidth() - (insets.left + insets.right) - lastw;
      int h = parent.getHeight() - (insets.top + insets.bottom);
      int w = (width&gt;100*(ncomponents-1))?100:width/ncols;
      int gap = width - w*ncols;
      int x = insets.left;
      int y = insets.top;
      for (int i=0;i&lt;ncomponents;i++) {
        int a = (gap&gt;0)?1:0;
        gap--;
        int cw = (i==ncols)?lastw:w+a;
        parent.getComponent(i).setBounds(x, y, cw, h);
        x += w + a;
      }
    }
  }
  @Override public String toString() {
    return getClass().getName();
  }
}
</code></pre>

### 解説
上記のサンプルでは、以下のような`LayoutManager`を作成して`JRadioButton`をタブ風に並べています。

- 最後のタブ(タブ追加ボタン)は常に幅固定
- 最後のタブの高さがタブエリアの高さ
- タブエリアの幅に余裕がある場合は、各タブ幅は`100px`で一定
- タブエリアの幅に余裕がない場合は、各タブ幅は均等

<!-- dummy comment line for breaking list -->

- その他
    - タブを削除した場合、先頭タブにフォーカスが移動する
    - 左の`JButton`(ダミー)は、タブエリアをラップする`JPanel(BorderLayout)`の`BorderLayout.WEST`に配置
    - アイコンはランダム

<!-- dummy comment line for breaking list -->

### 参考リンク
- [XP Style Icons - Windows Application Icon, Software XP Icons](http://www.icongalore.com/)
- [CardLayoutを使ってJTabbedPane風のコンポーネントを作成](http://terai.xrea.jp/Swing/CardLayoutTabbedPane.html)

<!-- dummy comment line for breaking list -->

### コメント
- タブをクリックした時ではなく、`mousePressed`で切り替えるように変更。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-03-21 (水) 18:46:30

<!-- dummy comment line for breaking list -->

