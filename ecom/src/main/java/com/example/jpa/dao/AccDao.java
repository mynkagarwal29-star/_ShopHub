package com.example.jpa.dao;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.example.jpa.model.Account;
public interface AccDao extends JpaRepository<Account, Long> {

	Account findByEmailAndPassword(String email, String pwd);

	Optional<Account> findByEmail(String email);

	  @Query("SELECT a FROM Account a WHERE a.role <> 'admin'")
	    List<Account> findAllUsers();

	  String findSec_aByEmail(String email);
}
