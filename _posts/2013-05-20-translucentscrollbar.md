---
layout: post
title: JScrollBarを半透明にする
category: swing
folder: TranslucentScrollBar
tags: [JScrollBar, JViewport, JScrollPane, Translucent, LayoutManager]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-05-20

## JScrollBarを半透明にする
半透明の`JScrollBar`を作成して、`JViewport`内部に配置します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/-X8o390yxqhI/UZjhjkgUrkI/AAAAAAAABsY/Aajtim-5-uE/s800/TranslucentScrollBar.png)

### サンプルコード
<pre class="prettyprint"><code>public JComponent makeTranslucentScrollBar(JScrollPane scrollPane) {
  scrollPane.setComponentZOrder(scrollPane.getVerticalScrollBar(), 0);
  scrollPane.setComponentZOrder(scrollPane.getViewport(), 1);
  scrollPane.getVerticalScrollBar().setOpaque(false);

  scrollPane.setLayout(new ScrollPaneLayout() {
    @Override public void layoutContainer(Container parent) {
      JScrollPane scrollPane = (JScrollPane)parent;

      Rectangle availR = scrollPane.getBounds();
      availR.x = availR.y = 0;

      Insets insets = parent.getInsets();
      availR.x = insets.left;
      availR.y = insets.top;
      availR.width  -= insets.left + insets.right;
      availR.height -= insets.top  + insets.bottom;

      Rectangle vsbR = new Rectangle();
      vsbR.width  = 12;
      vsbR.height = availR.height;
      vsbR.x = availR.x + availR.width - vsbR.width;
      vsbR.y = availR.y;

      if(viewport != null) {
        viewport.setBounds(availR);
      }
      if(vsb != null) {
        vsb.setVisible(true);
        vsb.setBounds(vsbR);
      }
    }
  });
  scrollPane.getVerticalScrollBar().setUI(new BasicScrollBarUI() {
    private final Dimension d = new Dimension();
    @Override protected JButton createDecreaseButton(int orientation) {
      return new JButton() {
        @Override public Dimension getPreferredSize() {
          return d;
        }
      };
    }
    @Override protected JButton createIncreaseButton(int orientation) {
      return new JButton() {
        @Override public Dimension getPreferredSize() {
          return d;
        }
      };
    }
    @Override protected void paintTrack(Graphics g, JComponent c, Rectangle r) {}
    private final Color defaultColor  = new Color(220,100,100,100);
    private final Color draggingColor = new Color(200,100,100,100);
    private final Color rolloverColor = new Color(255,120,100,100);
    @Override protected void paintThumb(Graphics g, JComponent c, Rectangle r) {
      Graphics2D g2 = (Graphics2D)g.create();
      g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                          RenderingHints.VALUE_ANTIALIAS_ON);
      Color color = null;
      JScrollBar sb = (JScrollBar)c;
      if(!sb.isEnabled() || r.width&gt;r.height) {
        return;
      }else if(isDragging) {
        color = draggingColor;
      }else if(isThumbRollover()) {
        color = rolloverColor;
      }else{
        color = defaultColor;
      }
      g2.setPaint(color);
      g2.fillRect(r.x,r.y,r.width-1,r.height-1);
      g2.setPaint(Color.WHITE);
      g2.drawRect(r.x,r.y,r.width-1,r.height-1);
      g2.dispose();
    }
    @Override protected void setThumbBounds(int x, int y, int width, int height) {
      super.setThumbBounds(x, y, width, height);
      //scrollbar.repaint(x, 0, width, scrollbar.getHeight());
      scrollbar.repaint();
    }
  });
  return scrollPane;
}
</code></pre>

### 解説
上記のサンプルでは、`JScrollBar`の増減ボタンのサイズを`0`、トラックを透明、つまみを半透明にして、`JViewport`内部に配置しています。

- `ScrollPaneLayout#layoutContainer(...)`をオーバーライドして、`JScrollBar`を`JViewport`の内部にオーバーラップするように配置
    - `scrollPane.setComponentZOrder(...)`で、`JScrollBar`と`JViewport`の`Z`軸の順序を変更
- `BasicScrollBarUI#createDecreaseButton()`、`BasicScrollBarUI#createIncreaseButton()`をオーバーライドして増減ボタンのサイズを`0`に設定
- `BasicScrollBarUI#paintTrack()`をオーバーライドしてトラックを非表示
    - トラックにつまみの残像が残るので、`BasicScrollBarUI#setThumbBounds`をオーバーライドして`JScrollBar`全体を再描画
- `BasicScrollBarUI#paintThumb()`をオーバーライドして半透明のつまみを描画

<!-- dummy comment line for breaking list -->

- 注:
    - `WindowsLookAndFeel`などでつまみの描画がチラつく？
    - `JTextArea`などをこのサンプルの`JViewport`に配置すると、`Caret`の点滅や、文字列の選択などでつまみの描画が乱れる
    - `JList`などの選択でも、つまみの描画が乱れる
        - `ListSelectionListener`や、`FocusListener`を追加して再描画することで回避
    - 横スクロールバーの表示に未対応

<!-- dummy comment line for breaking list -->

### コメント
- `ScrollPaneLayout`を変更してオーバーラップするより、`JLayer`などを使ってドラッグ可能な矩形を描画する方が簡単かもしれない…。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-05-20 (月) 17:20:39

<!-- dummy comment line for breaking list -->
