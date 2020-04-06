---
layout: post
category: swing
folder: HorizontalWrapComboPopup
title: JComboBoxのドロップダウンリストでセル配置をニュースペーパー・スタイルに設定する
tags: [JComboBox, JList, ComboPopup]
author: aterai
pubdate: 2020-03-23T18:45:14+09:00
description: JComboBoxのドロップダウンリストに配置されるJListのセルレイアウト方法をニュースペーパー・スタイルに変更します。
image: https://drive.google.com/uc?id=1LMv0w83y7RJ0-0V28KBL2DIppbJ9EM1P
comments: true
---
## 概要
`JComboBox`のドロップダウンリストに配置される`JList`のセルレイアウト方法をニュースペーパー・スタイルに変更します。

{% download https://drive.google.com/uc?id=1LMv0w83y7RJ0-0V28KBL2DIppbJ9EM1P %}

## サンプルコード
<pre class="prettyprint"><code>private static JComboBox&lt;Icon&gt; makeComboBox1(ComboBoxModel&lt;Icon&gt; model, Icon proto) {
  return new JComboBox&lt;Icon&gt;(model) {
    @Override public Dimension getPreferredSize() {
      Insets i = getInsets();
      int w = proto.getIconWidth();
      int h = proto.getIconHeight();
      return new Dimension(w * 3 + i.left + i.right, h + i.top + i.bottom);
    }

    @Override public void updateUI() {
      super.updateUI();
      setMaximumRowCount(3);
      setPrototypeDisplayValue(proto);

      ComboPopup popup = (ComboPopup) getAccessibleContext().getAccessibleChild(0);
      JList&lt;?&gt; list = popup.getList();
      list.setLayoutOrientation(JList.HORIZONTAL_WRAP);
      list.setVisibleRowCount(3);
      list.setFixedCellWidth(proto.getIconWidth());
      list.setFixedCellHeight(proto.getIconHeight());
    }
  };
}
</code></pre>

## 解説
- `PreferredSize`
    - `JComboBox#getPreferredSize()`をオーバーライドして`JComboBox`の幅をセルサイズの`3`倍になるよう変更
    - `ComboPopup#getList()`でドロップダウンリストに配置される`JList`を取得してセルの配置方法を`HORIZONTAL_WRAP`に変更
        - `JList`の下側に余計な余白が生成されてしまう？
    - `JComboBox#setMaximumRowCount(3)`、`JList#setVisibleRowCount(3)`で`3`行のセルを表示するよう変更
        - 片方だけ設定するとスクロールバーが表示されたり、余計な余白ができる場合がある
    - `JComboBox#setPrototypeDisplayValue(...)`、`JList#setFixedCellWidth(...)`、`JList#setFixedCellHeight(...)`でセルサイズを変更
        - `JComboBox#setPrototypeDisplayValue(...)`のみ指定する場合、セルの右に余分な余白が生成される？
- `PopupMenuListener`
    - `JComboBox#getPreferredSize()`をオーバーライドして`JComboBox`の幅をセルサイズと矢印ボタンの合計になるよう変更
        - このサンプルで使用している矢印ボタンの幅は`20px`固定
    - `PopupMenuListener`を追加してドロップダウンリストを開く直前だけ`JComboBox`の幅をセルサイズの`3`倍になるよう変更
    - `JList`の下側に余計な余白が生成されてしまうことを防ぐため`ListCellRenderer`を変更
        - デフォルトセルレンダラーの`Border`余白の合計分(`(top:1 + bottom:1) * 行:3 = 6px`)だけ高くなっている

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>private static JComboBox&lt;Icon&gt; makeComboBox2(ComboBoxModel&lt;Icon&gt; model, Icon proto) {
  JComboBox&lt;Icon&gt; combo = new JComboBox&lt;Icon&gt;(model) {
    @Override public Dimension getPreferredSize() {
      Insets i = getInsets();
      int w = proto.getIconWidth();
      int h = proto.getIconHeight();
      return new Dimension(20 + w + i.left + i.right, h + i.top + i.bottom);
    }

    @Override public void updateUI() {
      setRenderer(null);
      super.updateUI();
      setMaximumRowCount(3);
      setPrototypeDisplayValue(proto);
      ListCellRenderer&lt;? super Icon&gt; r = getRenderer();
      setRenderer((list, value, index, isSelected, cellHasFocus) -&gt; {
        Component c = r.getListCellRendererComponent(list, value, index, isSelected, cellHasFocus);
        if (c instanceof JLabel) {
          JLabel l = (JLabel) c;
          l.setIcon(value);
          l.setBorder(BorderFactory.createEmptyBorder());
        }
        return c;
      });

      ComboPopup popup = (ComboPopup) getAccessibleContext().getAccessibleChild(0);
      JList&lt;?&gt; list = popup.getList();
      list.setLayoutOrientation(JList.HORIZONTAL_WRAP);
      list.setVisibleRowCount(3);
      list.setFixedCellWidth(proto.getIconWidth());
      list.setFixedCellHeight(proto.getIconHeight());
    }
  };
  combo.addPopupMenuListener(new PopupMenuListener() {
    private boolean adjusting;

    @Override public void popupMenuWillBecomeVisible(PopupMenuEvent e) {
      JComboBox&lt;?&gt; combo = (JComboBox&lt;?&gt;) e.getSource();

      Insets i = combo.getInsets();
      int popupWidth = proto.getIconWidth() * 3 + i.left + i.right;

      Dimension size = combo.getSize();
      if (size.width &gt;= popupWidth) {
        return;
      }
      if (!adjusting) {
        adjusting = true;
        combo.setSize(popupWidth, size.height);
        combo.showPopup();
      }
      combo.setSize(size);
      adjusting = false;
    }

    @Override public void popupMenuWillBecomeInvisible(PopupMenuEvent e) {
      /* not needed */
    }

    @Override public void popupMenuCanceled(PopupMenuEvent e) {
      /* not needed */
    }
  });
  return combo;
}
</code></pre>

## 参考リンク
- [JComboBoxのドロップダウンリスト幅を指定値以上に保つ](https://ateraimemo.com/Swing/ComboPopupWidth.html)
- [JPopupMenuをボタンの長押しで表示](https://ateraimemo.com/Swing/PressAndHoldButton.html)

<!-- dummy comment line for breaking list -->

## コメント
