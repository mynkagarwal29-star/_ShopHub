package com.example.jpa.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

@Entity
@Table(name = "Orders")
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne
    private Account account;
    // Instead of Address entity, we embed fields directly here
    private String line1;
    private LocalDateTime orderDate;
    private String city;
    private String postal;
    private String country;
    private String status; // PENDING_PAYMENT, PAID, EXPIRED, CANCELLED
    private String delivery_status; // CONFIRMED , PACKED ,OUT_FOR_DELIVERY ,COMPLETED
    private double total;
    private double subtotal;
    private double tax;
    private double shipping;
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
    private List<OrderItem> items = new ArrayList<>();
    private String phoneNumber;  // <-- store phone as String
    @Column(name = "razorpay_payment_id")
    private String razorpayPaymentId;
    
    
    

    public String getRazorpayPaymentId() {
		return razorpayPaymentId;
	}

	public void setRazorpayPaymentId(String razorpayPaymentId) {
		this.razorpayPaymentId = razorpayPaymentId;
	}

	// getters and setters
    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    
    
    
    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }

    public Account getAccount() {
        return account;
    }
    public void setAccount(Account user) {
        this.account = user;
    }

    public String getLine1() {
        return line1;
    }
    public void setLine1(String line1) {
        this.line1 = line1;
    }

    public String getCity() {
        return city;
    }
    public void setCity(String city) {
        this.city = city;
    }

    public String getPostal() {
        return postal;
    }
    public void setPostal(String postal) {
        this.postal = postal;
    }

    public String getCountry() {
        return country;
    }
    public void setCountry(String country) {
        this.country = country;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public double getTotal() {
        return total;
    }
    public void setTotal(double total) {
        this.total = total;
    }

    public List<OrderItem> getItems() {
        return items;
    }
    public void setItems(List<OrderItem> items) {
        this.items = items;
    }
	public LocalDateTime getOrderDate() {
		return orderDate;
	}
	public void setOrderDate(LocalDateTime orderDate) {
		this.orderDate = orderDate;
	}

	public double getShipping() {
		return shipping;
	}

	public void setShipping(double shipping) {
		this.shipping = shipping;
	}

	public double getSubtotal() {
		return subtotal;
	}

	public void setSubtotal(double subtotal) {
		this.subtotal = subtotal;
	}

	public double getTax() {
		return tax;
	}

	public void setTax(double tax) {
		this.tax = tax;
	}

	public String getDelivery_status() {
		return delivery_status;
	}

	public void setDelivery_status(String delivery_status) {
		this.delivery_status = delivery_status;
	}
}
