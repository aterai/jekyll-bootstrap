---
layout: post
category: swing
folder: ToolTipInComboBox
title: JComboBoxの各アイテムやArrowButtonにそれぞれToolTipTextを設定する
tags: [JComboBox, JToolTip, JLayer]
author: aterai
pubdate: 2017-04-24T14:34:47+09:00
description: JComboBoxの各リストアイテムやArrowButtonに、それぞれ異なるToolTipTextを設定します。
image: https://drive.google.com/uc?id=1-hvVHO5A6M8VTO8QPye3epe-ZazLLTzfDQ
comments: true
---
## 概要
`JComboBox`の各リストアイテムや`ArrowButton`に、それぞれ異なる`ToolTipText`を設定します。

{% download https://drive.google.com/uc?id=1-hvVHO5A6M8VTO8QPye3epe-ZazLLTzfDQ %}

## サンプルコード
<pre class="prettyprint"><code>private static JComponent makeComboBox() {
  JComboBox&lt;String&gt; combo = new JComboBox&lt;&gt;(new String[] {"aaa", "bbbbb", "c"});
  combo.setRenderer(new DefaultListCellRenderer() {
    @Override public Component getListCellRendererComponent(
        JList&lt;?&gt; list, Object value, int index,
        boolean isSelected, boolean cellHasFocus) {
      Component c = super.getListCellRendererComponent(
          list, value, index, isSelected, cellHasFocus);
      if (c instanceof JComponent) {
        ((JComponent) c).setToolTipText(String.format("Item%d: %s", index, value));
      }
      return c;
    }
  });
  return new JLayer&lt;&gt;(combo, new ToolTipLayerUI&lt;&gt;());
}

class ToolTipLayerUI&lt;V extends JComboBox&gt; extends LayerUI&lt;V&gt; {
  @Override public void installUI(JComponent c) {
    super.installUI(c);
    if (c instanceof JLayer) {
      ((JLayer) c).setLayerEventMask(AWTEvent.MOUSE_MOTION_EVENT_MASK);
    }
  }
  @Override public void uninstallUI(JComponent c) {
    if (c instanceof JLayer) {
      ((JLayer) c).setLayerEventMask(0);
    }
    super.uninstallUI(c);
  }
  @Override protected void processMouseMotionEvent(MouseEvent e, JLayer&lt;? extends V&gt; l) {
    JComboBox&lt;?&gt; c = l.getView();
    if (e.getComponent() instanceof JButton) {
      c.setToolTipText("JButton");
    } else {
      c.setToolTipText("JComboBox: " + c.getSelectedItem());
    }
    super.processMouseMotionEvent(e, l);
  }
}
</code></pre>

## 解説
- `JComboBox`本体
    - `JComboBox#setToolTipText(...)`メソッドで`ToolTipText`を設定した場合、`ArrowButton`や編集可の場合の`JTextField`などのすべての子コンポーネントに同じテキストが設定される
        - 参考: `BasicComboBoxUI#updateToolTipTextForChildren()`
    - ドロップダウンリスト内のリストアイテムに`ToolTipText`は設定されない
- リストアイテム
    - セルレンダラーに`DefaultListCellRenderer#setToolTipText(...)`メソッドで`ToolTipText`を設定
- `ArrowButton`
    - `JComboBox`本体とは別の`ToolTipText`を設定するため、`JLayer`を使用
        - `LayerUI#processMouseMotionEvent(...)`をオーバーライドして、`JButton`上にマウスカーソルが入ったら`JButton#setToolTipText(...)`で`ToolTipText`を変更

<!-- dummy comment line for breaking list -->

- - - -
- `JComboBox`のドロップダウンリストを開いた状態でツールチップを表示すると描画がおかしくなる場合がある
    - `MetalLookAndFeel`のみ
    - ドロップダウンリストが`HeavyWeightWindow`か`LightWeightWindow`かは無関係

<!-- dummy comment line for breaking list -->



<pre class="prettyprint"><code>import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class CustomJComboBoxTest2 {
  public JComponent makeUI() {
    JComboBox&lt;String&gt; box = new JComboBox&lt;&gt;();
    box.addItem("Item 1");
    box.addItem("Item 2");
    box.setToolTipText("TooTip");

    JPanel p = new JPanel(new BorderLayout());
    p.setBorder(BorderFactory.createEmptyBorder(60, 20, 60, 20));
    p.add(box);
    return p;
  }
  public static void main(String... args) {
    EventQueue.invokeLater(() -&gt; {
      JFrame f = new JFrame();
      f.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
      f.getContentPane().add(new CustomJComboBoxTest2().makeUI());
      f.setSize(320, 240);
      f.setLocationRelativeTo(null);
      f.setVisible(true);
    });
  }
}
</code></pre>

## コメント
