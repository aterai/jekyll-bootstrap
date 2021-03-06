---
layout: post
category: swing
folder: ComboBoxEnterSelectablePopup
title: JComboBoxのポップアップメニューでEnterキーが入力された場合のActionListenerの動作をテストする
tags: [JComboBox, ActionListener, UIManager]
author: aterai
pubdate: 2017-07-10T15:41:36+09:00
description: 編集可能なJComboBoxのポップアップメニューでEnterキーが入力された場合のActionListenerの動作をテストします。
image: https://drive.google.com/uc?id=1IRqx7XfCe8R_uKdyEiatC5Ro-ucy_GPnZw
comments: true
---
## 概要
編集可能な`JComboBox`のポップアップメニューで<kbd>Enter</kbd>キーが入力された場合の`ActionListener`の動作をテストします。

{% download https://drive.google.com/uc?id=1IRqx7XfCe8R_uKdyEiatC5Ro-ucy_GPnZw %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("ComboBox.isEnterSelectablePopup", Boolean.TRUE);
</code></pre>

## 解説
- `ComboBox.isEnterSelectablePopup: false(default)`
    - ポップアップメニューが閉じている状態で、<kbd>Enter</kbd>キー入力やフォーカス移動で編集を終了するとアクションイベントが`2`回発生する
        - このアクションイベントで`JComboBox#getSelectedItem()`を実行するとエディタの値が取得される
    - ポップアップメニューが開いている状態で、<kbd>Enter</kbd>キーを入力するとアクションイベントが`1`回発生する
        - 編集不可の`JComboBox`の場合と同じ動作
        - このアクションイベントで`JComboBox#getSelectedItem()`を実行するとリストアイテムの値が取得される
- `ComboBox.isEnterSelectablePopup: true`
    - ポップアップメニューが閉じている状態で、<kbd>Enter</kbd>キー入力やフォーカス移動で編集を終了するとアクションイベントが`2`回発生する
        - このアクションイベントで`JComboBox#getSelectedItem()`を実行するとエディタの値が取得される
    - ポップアップメニューが開いている状態で、<kbd>Enter</kbd>キーを入力するとアクションイベントが`2`回発生する
        - このアクションイベントで`JComboBox#getSelectedItem()`を実行するとリストアイテムの値が取得される
    - 詳細は`javax/swing/plaf/basic/BasicComboBoxUI.java`を参照
        
        <pre class="prettyprint"><code>// Forces the selection of the list item
        boolean isEnterSelectablePopup = UIManager.getBoolean("ComboBox.isEnterSelectablePopup");
        if (!comboBox.isEditable() || isEnterSelectablePopup || ui.isTableCellEditor) {
          Object listItem = ui.popup.getList().getSelectedValue();
          if (listItem != null) {
            // Use the selected value from popup
            // to set the selected item in combo box,
            // but ensure before that JComboBox.actionPerformed()
            // won't use editor's value to set the selected item
            comboBox.getEditor().setItem(listItem);
            comboBox.setSelectedItem(listItem);
          }
        }
        comboBox.setPopupVisible(false);
</code></pre>
- 注:
    - `JComboBox#addItemListener(...)`で追加した`ItemListener`にはこの設定は影響しない
    - `UIManager.getBoolean("ComboBox.noActionOnKeyNavigation") == true`の場合、この設定は無視され`ComboBox.isEnterSelectablePopup: true`と同じ動作になる
        - ポップアップメニューが開いている状態で、<kbd>Enter</kbd>キーを入力するとアクションイベントが`2`回発生する
    - `ComboBox.isEnterSelectablePopup`の設定は<kbd>Enter</kbd>キーが入力されると毎回`UIManager.getBoolean("ComboBox.isEnterSelectablePopup")`で取得されるので、切替は`PopupMenuListener#popupMenuWillBecomeVisible(...)`メソッドをオーバーライドして実行

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JComboBox#addActionListener(ActionListener) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JComboBox.html#addActionListener-java.awt.event.ActionListener-)
- [JTextFieldにActionListenerを追加する](https://ateraimemo.com/Swing/TextFieldActionListener.html)

<!-- dummy comment line for breaking list -->

## コメント
