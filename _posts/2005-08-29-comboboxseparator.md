---
layout: post
category: swing
folder: ComboBoxSeparator
title: JComboBoxにJSeparatorを挿入
tags: [JComboBox, JSeparator, ListCellRenderer, ItemListener, ActionMap, InputMap]
author: aterai
pubdate: 2005-08-29T00:43:58+09:00
description: JComboBoxに選択できないJSeparatorを挿入します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTJt9fH4ZI/AAAAAAAAAU0/c9vovQi9Jvo/s800/ComboBoxSeparator.png
comments: true
---
## 概要
`JComboBox`に選択できない`JSeparator`を挿入します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTJt9fH4ZI/AAAAAAAAAU0/c9vovQi9Jvo/s800/ComboBoxSeparator.png %}

## サンプルコード
<pre class="prettyprint"><code>JComboBox&lt;Object&gt; combo = new JComboBox&lt;&gt;();
combo.setRenderer(new DefaultListCellRenderer() {
  @Override public Component getListCellRendererComponent(
      JList list, Object value, int index, boolean isSelected, boolean cellHasFocus) {
    if (value instanceof JSeparator) {
      return (Component) value;
    } else {
      return super.getListCellRendererComponent(list, value, index, isSelected, cellHasFocus);
    }
  }
});
DefaultComboBoxModel model = new DefaultComboBoxModel() {
  @Override public void setSelectedItem(Object o) {
    if (o instanceof JSeparator) {
      return;
    }
    super.setSelectedItem(o);
  }
};
model.addElement("aaaaa");
model.addElement(new JSeparator());
model.addElement("bbbbb");
combo.setModel(model);
</code></pre>

## 解説
- `ListCellRenderer`
    - `JSeparator`が選択された場合は、セル描画`Component`として`JSeparator`を返す`ListCellRenderer`を設定
- `DefaultComboBoxModel`
    - `JSeparator`が選択された場合は何もしないよう、`setSelectedItem`メソッドをオーバーライド

<!-- dummy comment line for breaking list -->

`DefaultComboBoxModel#setSelectedItem`メソッドをオーバーライドする代わりに、以下のように`JSeparator`が選択された場合はひとつ前の`Item`に戻すような`ItemListener`を追加しても同様になります。

<pre class="prettyprint"><code>combobox.addItemListener(new ItemListener() {
  private Object prev;
  @Override public void itemStateChanged(ItemEvent e) {
    if (e.getStateChange() == ItemEvent.SELECTED) {
      Object obj = e.getItem();
      if (obj instanceof JSeparator) {
        if (prev == null) {
          prev = combobox.getItemAt(0);
        }
        combobox.setSelectedItem(prev);
      } else {
        prev = obj;
      }
    }
  }
});
</code></pre>

さらに、<kbd>Up</kbd><kbd>Down</kbd>キーでの選択状態移動を可能にする(`JSeparator`なら飛ばす)場合は、以下のようなキーストロークのアクションを設定する必要があります。

<pre class="prettyprint"><code>Action up = new AbstractAction() {
  @Override public void actionPerformed(ActionEvent e) {
    int index = combobox.getSelectedIndex();
    if (index == 0) {
      return;
    }
    Object o = combobox.getItemAt(index - 1);
    if (o instanceof JSeparator) {
      combobox.setSelectedIndex(index - 2);
    } else {
      combobox.setSelectedIndex(index - 1);
    }
  }
};
Action down = new AbstractAction() {
  @Override public void actionPerformed(ActionEvent e) {
    int index = combobox.getSelectedIndex();
    if (index == combobox.getItemCount() - 1) {
      return;
    }
    Object o = combobox.getItemAt(index + 1);
    if (o instanceof JSeparator) {
      combobox.setSelectedIndex(index + 2);
    } else {
      combobox.setSelectedIndex(index + 1);
    }
  }
};
ActionMap am = combobox.getActionMap();
am.put("selectPrevious3", up);
am.put("selectNext3", down);
InputMap im = combobox.getInputMap(JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT);
im.put(KeyStroke.getKeyStroke(KeyEvent.VK_UP, 0),      "selectPrevious3");
im.put(KeyStroke.getKeyStroke(KeyEvent.VK_KP_UP, 0),   "selectPrevious3");
im.put(KeyStroke.getKeyStroke(KeyEvent.VK_DOWN, 0),    "selectNext3");
im.put(KeyStroke.getKeyStroke(KeyEvent.VK_KP_DOWN, 0), "selectNext3");
</code></pre>

## 参考リンク
- [JComboBoxのアイテムをBorderで修飾してグループ分け](https://ateraimemo.com/Swing/BorderSeparator.html)

<!-- dummy comment line for breaking list -->

## コメント
- <kbd>Up</kbd><kbd>Down</kbd>キーでの選択状態移動に対応しました。 -- *aterai* 2007-08-10 (金) 18:54:05

<!-- dummy comment line for breaking list -->
