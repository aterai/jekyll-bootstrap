---
layout: post
category: swing
folder: HorizontalVisibility
title: JTextFieldの表示領域をJScrollBarでスクロールする
tags: [JTextField, JScrollBar, BoundedRangeModel]
author: aterai
pubdate: 2014-05-12T00:05:11+09:00
description: JTextFieldの表示領域をJScrollBarでスクロール可能にします。
image: https://lh3.googleusercontent.com/-e-5Z2Ze6fmU/U4Q5K7nrzqI/AAAAAAAACGQ/9vdUHpxI2VA/s800/HorizontalVisibility.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2015/04/scrollbar-for-jtextfield.html
    lang: en
comments: true
---
## 概要
`JTextField`の表示領域を`JScrollBar`でスクロール可能にします。

{% download https://lh3.googleusercontent.com/-e-5Z2Ze6fmU/U4Q5K7nrzqI/AAAAAAAACGQ/9vdUHpxI2VA/s800/HorizontalVisibility.png %}

## サンプルコード
<pre class="prettyprint"><code>scroller.setModel(textField.getHorizontalVisibility());
</code></pre>

## 解説
上記のサンプルでは、`JTextField#getHorizontalVisibility()`で取得した`BoundedRangeModel`(可視領域のモデル)を`JScrollBar`に設定することで、これを使用したスクロールや現在の可視領域の位置、幅の表示などが可能になっています。

- `JScrollPane + VERTICAL_SCROLLBAR_NEVER`
    - `JTextField`をスクロールバーを常に非表示に設定した`JScrollPane`に追加
- `BoundedRangeModel: textField.getHorizontalVisibility()`
    - `JTextField`と水平スクロールバー`JScrollBar(Adjustable.HORIZONTAL)`を別々に配置
    - `JTextField#getHorizontalVisibility()`で`BoundedRangeModel`を取得し、これを`JScrollBar#setModel(...)`で設定して二つを同期する
- `BoundedRangeModel+textField.ArrowButtonlessScrollBarUI`
    - 上の`JScrollBar`に、矢印ボタンなどを非表示、ノブを半透明化などを行う`ScrollBarUI`を設定

<!-- dummy comment line for breaking list -->

- - - -
- `setCaretPosition: 0`: `JTextField#setCaretPosition(0);`は`JTextField`にフォーカスが無い場合無効？
    - `JScrollBar`が同期しない場合がある
- `setScrollOffset: 0`: `JScrollBar`のノブがマウスドラッグに反応しなくなる場合がある？
- ノブの表示: 文字列をすべて削除するなどしても、ノブが非表示にならない
    - `1px`の余白？、以下のようなリスナーで回避するテストを追加

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class EmptyThumbHandler extends ComponentAdapter implements DocumentListener {
  private final BoundedRangeModel emptyThumbModel
    = new DefaultBoundedRangeModel(0, 1, 0, 1);
  private final JTextField textField;
  private final JScrollBar scroller;
  public EmptyThumbHandler(JTextField textField, JScrollBar scroller) {
    super();
    this.textField = textField;
    this.scroller = scroller;
  }
  private void changeThumbModel() {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        BoundedRangeModel m = textField.getHorizontalVisibility();
        int iv = m.getMaximum() - m.getMinimum() - m.getExtent() - 1; //-1:bug?
        if (iv &lt;= 0) {
          scroller.setModel(emptyThumbModel);
        } else {
          scroller.setModel(textField.getHorizontalVisibility());
        }
      }
    });
  }
  @Override public void componentResized(ComponentEvent e) {
    changeThumbModel();
  }
  @Override public void insertUpdate(DocumentEvent e) {
    changeThumbModel();
  }
  @Override public void removeUpdate(DocumentEvent e) {
    changeThumbModel();
  }
  @Override public void changedUpdate(DocumentEvent e) {
    changeThumbModel();
  }
}
</code></pre>

- - - -
- 以下は、サイズ`0`の`ArrowButton`を使用する`ScrollBarUI`を設定する方法

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class ArrowButtonlessScrollBarUI extends BasicScrollBarUI {
  private static final Color DEFAULT_COLOR  = new Color(220, 100, 100, 100);
  private static final Color DRAGGING_COLOR = new Color(200, 100, 100, 100);
  private static final Color ROLLOVER_COLOR = new Color(255, 120, 100, 100);
  @Override protected JButton createDecreaseButton(int orientation) {
    return new ZeroSizeButton();
  }
  @Override protected JButton createIncreaseButton(int orientation) {
    return new ZeroSizeButton();
  }
  @Override protected void paintTrack(Graphics g, JComponent c, Rectangle r) {
    //Graphics2D g2 = (Graphics2D) g.create();
    //g2.setPaint(new Color(100, 100, 100, 100));
    //g2.fillRect(r.x, r.y, r.width - 1, r.height - 1);
    //g2.dispose();
  }
  @Override protected void paintThumb(Graphics g, JComponent c, Rectangle r) {
    JScrollBar sb = (JScrollBar) c;
    if (!sb.isEnabled()) {
      return;
    }
    BoundedRangeModel m = sb.getModel();
    int iv = m.getMaximum() - m.getMinimum() - m.getExtent() - 1; //-1:bug?
    if (iv &gt; 0) {
      Graphics2D g2 = (Graphics2D) g.create();
      g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                          RenderingHints.VALUE_ANTIALIAS_ON);
      Color color;
      if (isDragging) {
        color = DRAGGING_COLOR;
      } else if (isThumbRollover()) {
        color = ROLLOVER_COLOR;
      } else {
        color = DEFAULT_COLOR;
      }
      g2.setPaint(color);
      g2.fillRect(r.x, r.y, r.width - 1, r.height - 1);
      g2.dispose();
    }
  }
}
</code></pre>

- - - -
- `JScrollPane scroll = new JScrollPane(new JTextField(TEXT), ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER, ScrollPaneConstants.HORIZONTAL_SCROLLBAR_ALWAYS);`
    - 縦スクロールバーを非表示にした`JScrollPane`を使用する場合、`JTextField`内の文字列選択でスクロールしない
    - 文字列を適当な長さまで削除するとノブが非表示になる

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTextField#getHorizontalVisibility() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTextField.html#getHorizontalVisibility--)

<!-- dummy comment line for breaking list -->

## コメント
- 可視領域の幅の表示を考えると`ArrowButton`は不要なので、[JScrollBarを半透明にする](https://ateraimemo.com/Swing/TranslucentScrollBar.html)のような外見の`JScrollBar`を使用した方が良いかもしれない。 -- *aterai* 2014-05-14 (水) 16:05:32
- サンプルの追加と、スクリーンショットの更新。 -- *aterai* 2014-05-27 (火) 16:12:38

<!-- dummy comment line for breaking list -->
