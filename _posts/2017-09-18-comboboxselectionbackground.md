---
layout: post
category: swing
folder: ComboBoxSelectionBackground
title: JComboBoxのドロップダウンリストでの選択背景色を変更する
tags: [JComboBox, JList, UIManager]
author: aterai
pubdate: 2017-09-18T18:34:08+09:00
description: JComboBoxのドロップダウンリストで使用されるJListの選択背景色と選択文字色を変更します。
image: https://drive.google.com/uc?id=1j4KzCS-He6w9JuyRopBvRfEgr3S-XgXxrA
comments: true
---
## 概要
`JComboBox`のドロップダウンリストで使用される`JList`の選択背景色と選択文字色を変更します。

{% download https://drive.google.com/uc?id=1j4KzCS-He6w9JuyRopBvRfEgr3S-XgXxrA %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("ComboBox.selectionBackground", Color.PINK);
UIManager.put("ComboBox.selectionForeground", Color.CYAN);

String[] model = {"111", "2222", "33333"};

JComboBox&lt;String&gt; combo0 = new JComboBox&lt;&gt;(model);

JComboBox&lt;String&gt; combo1 = new JComboBox&lt;String&gt;(model) {
  @Override public void updateUI() {
    super.updateUI();
    Object o = getAccessibleContext().getAccessibleChild(0);
    if (o instanceof ComboPopup) {
      JList list = ((ComboPopup) o).getList();
      list.setSelectionForeground(Color.WHITE);
      list.setSelectionBackground(Color.ORANGE);
    }
  }
};

JComboBox&lt;String&gt; combo2 = new JComboBox&lt;String&gt;(model) {
  @Override public void updateUI() {
    super.updateUI();
    setRenderer(new DefaultListCellRenderer() {
      @Override public Component getListCellRendererComponent(
          JList list, Object value, int index,
          boolean isSelected, boolean hasFocus) {
        JLabel l = (JLabel) super.getListCellRendererComponent(
            list, value, index, isSelected, hasFocus);
        if (isSelected) {
          l.setForeground(Color.WHITE);
          l.setBackground(Color.ORANGE);
        } else {
          l.setForeground(Color.BLACK);
          l.setBackground(Color.WHITE);
        }
        return l;
      }
    });
  }
};
</code></pre>

## 解説
- `UIManager.put(ComboBox.selection*, ...)`
    - `UIManager.put("ComboBox.selectionBackground", bgc);`、`UIManager.put("ComboBox.selectionForeground", fgc);`を使用して`JList`の選択背景色と選択文字色を変更
    - ドロップダウンリストで使用される`JList`のみが対象
    - `LookAndFeel`に依存し、例えば`NimbusLookAndFeel`ではどちらの指定も無効
- `ComboPopup.getList().setSelection*(...)`
    - `JComboBox#getAccessibleContext()#getAccessibleChild(0)`で`ComboPopup`を取得
    - `ComboPopup#getList()`メソッドでドロップダウンリストで使用される`JList`を取得
    - `JList#setSelectionForeground(...)`、`JList#setSelectionBackground(...)`メソッドを使用してその選択背景色と選択文字色を変更
- `DefaultListCellRenderer`
    - 参考: [JComboBoxの文字色を変更する](https://ateraimemo.com/Swing/ComboBoxForegroundColor.html)
    - `DefaultListCellRenderer#getListCellRendererComponent(...)`メソッドをオーバーライドして選択背景色と選択文字色を変更
    - `JComboBox`本体のフォーカス時の`Border`(`WindowsLookAndFeel`の場合は`WindowsBorders.DashedBorder`)が非表示になる
        - 回避方法: セルの描画を`DefaultListCellRenderer`を継承するレンダラーではなく、`JComboBox#getRenderer()`で取得した`LookAndFeel`デフォルトのレンダラーに移譲するなどの方法がある
            
            <pre class="prettyprint"><code>JComboBox&lt;String&gt; combo3 = new JComboBox&lt;String&gt;(model) {
              @Override public void updateUI() {
                setRenderer(null);
                super.updateUI();
                ListCellRenderer&lt;? super String&gt; defaultRenderer = getRenderer();
                setRenderer(new ListCellRenderer&lt;String&gt;() {
                  @Override public Component getListCellRendererComponent(
                      JList&lt;? extends String&gt; list, String value, int index,
                      boolean isSelected, boolean hasFocus) {
                    JLabel l = (JLabel) defaultRenderer.getListCellRendererComponent(
                        list, value, index, isSelected, hasFocus);
                    if (isSelected) {
                      l.setForeground(Color.WHITE);
                      l.setBackground(Color.ORANGE);
                    } else {
                      l.setForeground(Color.BLACK);
                      l.setBackground(Color.WHITE);
                    }
                    return l;
                  }
                });
              }
            };
</code></pre>
        - * 参考リンク [#reference]
- [JComboBoxの色を変更](https://ateraimemo.com/Swing/ColorComboBox.html)
- [JComboBoxの文字色を変更する](https://ateraimemo.com/Swing/ComboBoxForegroundColor.html)
- [ComboPopup#getList() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/basic/ComboPopup.html#getList--)

<!-- dummy comment line for breaking list -->

## コメント
