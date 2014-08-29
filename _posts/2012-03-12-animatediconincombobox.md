---
layout: post
title: JComboBoxにAnimated GIFを表示する
category: swing
folder: AnimatedIconInComboBox
tags: [JComboBox, ImageIcon, ImageObserver, BasicComboPopup, JList]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-03-12

## JComboBoxにAnimated GIFを表示する
`JComboBox`と、そのドロップダウンリストに`Animated GIF`を表示します。

{% download https://lh3.googleusercontent.com/-kS7gIhaebeM/T12ukNN94JI/AAAAAAAABJ8/wM8SvLNzWEE/s800/AnimatedIconInComboBox.png %}

### サンプルコード
<pre class="prettyprint"><code>private static ImageIcon makeImageIcon(URL url, final JComboBox combo, final int row) {
  ImageIcon icon = new ImageIcon(url);
  //Wastefulness: icon.setImageObserver(combo);
  icon.setImageObserver(new ImageObserver() {
    //@see http://www2.gol.com/users/tame/swing/examples/SwingExamples.html
    @Override public boolean imageUpdate(Image img, int infoflags, int x, int y, int w, int h) {
      if(combo.isShowing() &amp;&amp; (infoflags &amp; (FRAMEBITS|ALLBITS)) != 0) {
        if(combo.getSelectedIndex()==row) {
          combo.repaint();
        }
        BasicComboPopup p = (BasicComboPopup)combo.getAccessibleContext().getAccessibleChild(0);
        JList list = p.getList();
        if(list.isShowing()) {
          list.repaint(list.getCellBounds(row, row));
        }
      }
      return (infoflags &amp; (ALLBITS|ABORT)) == 0;
    };
  });
  return icon;
}
</code></pre>

### 解説
- `JComboBox`自体が非表示(`JComboBox#isShowing(...)==false`)の場合は、再描画しない
- `Animated GIF`が選択されている(`JComboBox#getSelectedIndex()==row`)場合のみ、`JComboBox#repaint()`で再描画する
- `ドロップダウンリスト`が表示されている場合、`Animated GIF`の表示されている領域(`JList#getCellBounds(row, row)`で取得)だけ再描画

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JTableのセルにAnimated GIFを表示する](http://terai.xrea.jp/Swing/AnimatedIconInTableCell.html)

<!-- dummy comment line for breaking list -->

### コメント
