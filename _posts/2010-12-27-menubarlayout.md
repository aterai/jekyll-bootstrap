---
layout: post
title: JMenuBarのJMenuを折り返し
category: swing
folder: MenuBarLayout
tags: [JMenuBar, JMenu, LayoutManager, FlowLayout]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-12-27

## JMenuBarのJMenuを折り返し
`JMenuBar`のレイアウトマネージャーを変更して、`JMenu`を折り返して表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TRf4-liTfjI/AAAAAAAAAwk/CURxxE6iDqk/s800/MenuBarLayout.png)

### サンプルコード
<pre class="prettyprint"><code>JMenuBar menuBar = new JMenuBar();
menuBar.setLayout(new FlowLayout(FlowLayout.LEFT,2,2) {
  @Override public Dimension preferredLayoutSize(Container target) {
    synchronized (target.getTreeLock()) {
      int targetWidth = target.getSize().width;
      if (targetWidth == 0) targetWidth = Integer.MAX_VALUE;
      Insets insets = target.getInsets();
      int hgap = getHgap();
      int vgap = getVgap();
      int maxWidth = targetWidth - (insets.left + insets.right);
      int height   = vgap;
      int rowWidth = hgap, rowHeight = 0;
      int nmembers = target.getComponentCount();
      for(int i = 0; i &lt; nmembers; i++) {
        Component m = target.getComponent(i);
        if(m.isVisible()) {
          Dimension d = m.getPreferredSize();
          if(rowWidth + d.width &gt; maxWidth) {
            height += rowHeight;
            rowWidth = hgap;
            rowHeight = 0;
          }
          rowWidth += d.width + hgap;
          rowHeight = Math.max(rowHeight, d.height + vgap);
        }
      }
      height += rowHeight + insets.top  + insets.bottom;
      return new Dimension(targetWidth, height);
    }
  }
};
</code></pre>

### 解説
上記のサンプルでは、`JMenuBar`(デフォルトのレイアウトマネージャーは`BoxLayout`)に、`FlowLayout`を継承して折り返しを行うレイアウトマネージャを設定して、`JMenu`がフレームの幅に収まらない場合は折り返して表示するようにしています。

- - - -
上記のサンプルでは、`BorderLayout`を設定した`JPanel#add(menubar, BorderLayout.NORTH)`として`JMenuBar`を追加していますが、`JFrame#setJMenuBar`メソッドを使用した場合、以下のような不具合？があります。

- `JFrame`の最大化、最小化で折り返しが更新されない
    - 以下のような、`WindowStateListener`を`JFrame`に追加し、`ContentPane`を`revalidate()`して回避
        
        <pre class="prettyprint"><code>frame.addWindowStateListener(new WindowAdapter() {
          @Override public void windowStateChanged(final WindowEvent e) {
            EventQueue.invokeLater(new Runnable() {
              @Override public void run() {
                System.out.println("windowStateChanged");
                JFrame f = (JFrame)e.getWindow();
                ((JComponent)f.getContentPane()).revalidate();
              }
            });
          }
        });
        //frame.getContentPane().addComponentListener(new ComponentAdapter() {
        //  @Override public void componentResized(ComponentEvent e) {
        //    ((JComponent)e.getSource()).revalidate();
        //  }
        //});
</code></pre>
    - または、以下のように、`FlowLayout#layoutContainer`をオーバーライドすることで回避
        
        <pre class="prettyprint"><code>//http://tips4java.wordpress.com/2008/11/06/wrap-layout/
        //WrapLayout.java
        //Rob Camick on November 6, 2008
        private Dimension preferredLayoutSize;
        @Override public void layoutContainer(Container target) {
          Dimension size = preferredLayoutSize(target);
          if(size.equals(preferredLayoutSize)) {
            super.layoutContainer(target);
          }else{
            preferredLayoutSize = size;
            Container top = target;
            while(!(top instanceof Window) &amp;&amp; top.getParent() != null) {
              top = top.getParent();
            }
            top.validate();
          }
        }
</code></pre>
- `JFrame#pack()`しても、`JFrame`のサイズが変更されない
    - `JFrame#setSize(...)`に変更することで回避

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Wrap Layout « Java Tips Weblog](http://tips4java.wordpress.com/2008/11/06/wrap-layout/)

<!-- dummy comment line for breaking list -->

### コメント