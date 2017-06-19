---
layout: post
category: swing
folder: CheckedComboBox
title: JComboBoxのアイテムとして表示したJCheckBoxを複数選択する
tags: [JComboBox, JCheckBox]
author: aterai
pubdate: 2016-05-23T00:06:37+09:00
description: JComboBoxのアイテムとしてJCheckBoxを表示し、ドロップダウンリストを開いたままこれを複数選択可能に設定します。
image: https://lh3.googleusercontent.com/-I-fHfvCX-IU/V0G4uliNHdI/AAAAAAAAOX0/-746I_MG_jQkqTu1cniGzJqqu3xbc1khACCo/s800/CheckedComboBox.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2016/07/select-multiple-jcheckbox-in-jcombobox.html
    lang: en
comments: true
---
## 概要
`JComboBox`のアイテムとして`JCheckBox`を表示し、ドロップダウンリストを開いたままこれを複数選択可能に設定します。

{% download https://lh3.googleusercontent.com/-I-fHfvCX-IU/V0G4uliNHdI/AAAAAAAAOX0/-746I_MG_jQkqTu1cniGzJqqu3xbc1khACCo/s800/CheckedComboBox.png %}

## サンプルコード
<pre class="prettyprint"><code>class CheckedComboBox&lt;E extends CheckableItem&gt; extends JComboBox&lt;E&gt; {
  private boolean keepOpen;
  private transient ActionListener listener;

  protected CheckedComboBox() {
    super();
  }
  protected CheckedComboBox(ComboBoxModel&lt;E&gt; aModel) {
    super(aModel);
  }
  protected CheckedComboBox(E[] m) {
    super(m);
  }
  @Override public Dimension getPreferredSize() {
    return new Dimension(200, 20);
  }
  @Override public void updateUI() {
    setRenderer(null);
    removeActionListener(listener);
    super.updateUI();
    listener = e -&gt; {
      if (e.getModifiers() == InputEvent.BUTTON1_MASK) {
        updateItem(getSelectedIndex());
        keepOpen = true;
      }
    };
    setRenderer(new CheckBoxCellRenderer&lt;CheckableItem&gt;());
    addActionListener(listener);
    getInputMap(JComponent.WHEN_FOCUSED).put(
        KeyStroke.getKeyStroke(KeyEvent.VK_SPACE, 0), "checkbox-select");
    getActionMap().put("checkbox-select", new AbstractAction() {
      @Override public void actionPerformed(ActionEvent e) {
        Accessible a = getAccessibleContext().getAccessibleChild(0);
        if (a instanceof BasicComboPopup) {
          BasicComboPopup pop = (BasicComboPopup) a;
          updateItem(pop.getList().getSelectedIndex());
        }
      }
    });
  }
  private void updateItem(int index) {
    if (isPopupVisible()) {
      E item = getItemAt(index);
      item.selected ^= true;
      setSelectedIndex(-1);
      setSelectedItem(item);
    }
  }
  @Override public void setPopupVisible(boolean v) {
    if (keepOpen) {
      keepOpen = false;
    } else {
      super.setPopupVisible(v);
    }
  }
}
</code></pre>

## 解説
- タイトルと選択状態をもつアイテムオブジェクト`CheckableItem`を作成し、そのモデルとして`ComboBoxModel<CheckableItem>`を作成
- `CheckBoxCellRenderer<E extends CheckableItem>`を作成し、チェック状態を表示
    - `JComboBox`本体: レンダラーに`JLabel`を使用し、選択されている`CheckableItem`のタイトルを収集してカンマで結合して一覧表示
    - ドロップダウンリスト: レンダラーに`JCheckBox`を使用し、チェック状態とタイトルを表示
- `JComboBox`に`ActionListener`を追加し、マウスの左クリックかつドロップダウンリストが表示されている場合は、選択されたアイテムのチェック状態を反転
    - この場合は、ドロップダウンリストを閉じないように、`JComboBox#setPopupVisible(...)`をオーバーライド
- <kbd>Space</kbd>キーでアイテムが選択された場合は、`BasicComboPopup`から`JList`を取得し、その選択アイテムを取得する
    - この場合、`JComboBox#getSelectedIndex()`などを使用すると、ハイライト(`cellHasFocus`)されているアイテムではなく、選択状態(`isSelected`)のアイテムが取得される

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JComboBoxのドロップダウンリスト中にあるアイテムの状態を更新する](http://ateraimemo.com/Swing/UpdateComboBoxItem.html)

<!-- dummy comment line for breaking list -->

## コメント
