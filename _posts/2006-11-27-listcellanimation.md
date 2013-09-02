---
layout: post
title: JListのセルのアニメーション
category: swing
folder: ListCellAnimation
tags: [JList, ListCellRenderer, Animation]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-11-27

## JListのセルのアニメーション
`JList`の選択されたセルをアニメーションさせます。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTPa7B8VkI/AAAAAAAAAd8/uLpJ50Oxwf8/s800/ListCellAnimation.png)

### サンプルコード
<pre class="prettyprint"><code>class AnimeListCellRenderer extends JPanel implements ListCellRenderer {
  private static final Color selectedColor = new Color(230,230,255);
  private final AnimeIcon icon = new AnimeIcon();
  private final MarqueeLabel label = new MarqueeLabel();
  private final javax.swing.Timer animator;
  private final JList list;
  private boolean isRunning = false;
  public AnimeListCellRenderer(final JList l) {
    super(new BorderLayout());
    this.list = l;
    animator = new javax.swing.Timer(80, new ActionListener() {
      public void actionPerformed(ActionEvent e) {
        int i = l.getSelectedIndex();
        if(isRunning=(i&gt;=0)) l.repaint(l.getCellBounds(i,i));
      }
    });
    setOpaque(true);
    add(icon,  BorderLayout.WEST);
    add(label);
    animator.start();
  }
  public Component getListCellRendererComponent(JList list, Object object,
            int index, boolean isSelected, boolean cellHasFocus) {
    setBackground(isSelected ? selectedColor : list.getBackground());
    label.setText((object==null) ? "" : object.toString());
    animate_index = index;
    return this;
  }
  private boolean isAnimatingCell() {
    return isRunning &amp;&amp; animate_index==list.getSelectedIndex();
  }
  int animate_index = -1;
  private class MarqueeLabel extends JLabel {
  //...
</code></pre>

### 解説
上記のサンプルでは、セルが選択されると左のアイコンがアニメーションし、文字列がクリップされている場合は、スクロールするようになっています。

~~選択されたセルだけ再描画しているのではなく、`ActionListener`を実装したセルレンダラーを作成して`JList`全体を`repaint`しています。~~
選択されたセルだけ再描画してアニメーションを行っています。

### 参考リンク
- [Timerでアニメーションするアイコンを作成](http://terai.xrea.jp/Swing/AnimeIcon.html)
- [GlyphVectorで文字列を電光掲示板風にスクロール](http://terai.xrea.jp/Swing/ScrollingMessage.html)

<!-- dummy comment line for breaking list -->

### コメント
- 選択されたセルのみ再描画、`JScrollPane`に対応、スクリーンショット更新。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-05-13 (火) 14:53:51

<!-- dummy comment line for breaking list -->

